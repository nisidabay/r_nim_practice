#!/usr/bin/env bash
# Regenerate Fibonacci study reminders for this repo.
# Idempotent: running it multiple times is safe.
# Usage: ./regenerate_crons.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SCHEDULE_FILE="$REPO_DIR/learning_schedule.md"
QUEUE_DIR="$REPO_DIR/.fibonacci/queue"

echo "🧠 Regenerating Fibonacci plan..."
echo ""

# Validate input file exists
if [[ ! -f "$SCHEDULE_FILE" ]]; then
    echo "❌ learning_schedule.md not found at $SCHEDULE_FILE"
    echo "   Run the course generator to create it first."
    exit 1
fi

# Clean and recreate queue
rm -rf "$QUEUE_DIR"
mkdir -p "$QUEUE_DIR"

# Expected table format (parsed line by line):
#   | Day | # | Unit | Activity |
#   |-----|---|------|----------|
#   | 1 | 1 | 01_hello | Print and run your first program |
#
# Parsing terminates at the first "## " heading after the table starts.

in_table=false
header_passed=false
session_num=0
errors=0

while IFS= read -r line; do
    # Strip leading/trailing whitespace
    stripped="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    # Detect table start: a pipe-prefixed line where the first cell
    # starts with a digit (data row) or contains "Day" (header row).
    if [[ $stripped == \|* ]]; then
        # Skip separator lines (|---| pattern)
        if echo "$stripped" | grep -qE '^\|[-[:space:]]+\|'; then
            header_passed=true
            continue
        fi

        # Parse pipe-delimited columns
        IFS='|' read -ra cols <<< "$stripped"
        # Trim whitespace from each column
        for i in "${!cols[@]}"; do
            cols[$i]=$(echo "${cols[$i]}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        done

        day="${cols[1]}"
        num="${cols[2]}"
        unit="${cols[3]}"
        activity="${cols[4]}"

        # Skip header row (looks like "Day" in col 1)
        if [[ $day == "Day" ]] || [[ $day == "day" ]] || [[ $day == "Día" ]]; then
            header_passed=true
            continue
        fi

        # Must be a data row — validate
        if [[ -z $day ]] || [[ -z $num ]] || [[ -z $unit ]]; then
            if [[ $header_passed == true ]]; then
                echo "  ⚠️  Skipping malformed row: ${stripped:0:60}..."
                errors=$((errors + 1))
            fi
            continue
        fi

        in_table=true
        header_passed=true

        # Ensure num is a positive integer
        if ! echo "$num" | grep -qE '^[0-9]+$'; then
            echo "  ⚠️  Invalid session number '$num' in row: ${stripped:0:60}..."
            errors=$((errors + 1))
            continue
        fi

        fname=$(printf "session_%03d.md" "$num")
        cat > "$QUEUE_DIR/$fname" <<- EOFSESSION
# Fibonacci Session $num — Day $day

## $unit

$activity

---

📁 Repo: $REPO_DIR

✅ When you finish:
   rm .fibonacci/queue/$fname
EOFSESSION
        session_num=$((session_num + 1))
    elif [[ $in_table == true ]] && [[ $stripped == "## "* ]]; then
        break
    fi
done < "$SCHEDULE_FILE"

# Report results
if [[ $errors -gt 0 ]]; then
    echo "  ⚠️  $errors row(s) had issues (skipped)"
fi

if [[ $session_num -eq 0 ]]; then
    echo "❌ No sessions found in learning_schedule.md"
    echo "   Expected format:"
    echo ""
    echo "   | Day | # | Unit | Activity |"
    echo "   |-----|---|------|----------|"
    echo "   | 1 | 1 | 01_hello | Print and run |"
    echo ""
    echo "   Check that the table in $SCHEDULE_FILE matches this format."
    exit 1
fi

echo "✅ $session_num reminders generated in .fibonacci/queue/"
echo ""
echo "📋 To see the next one: ls .fibonacci/queue/ | head -1"
echo "📋 To see how many remain: ls .fibonacci/queue/ | wc -l"
echo ""
echo "💡 When you finish a session: rm .fibonacci/queue/session_NNN.md"
