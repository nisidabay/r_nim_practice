# Create directory structure
mkdir -p ~/bin/ollama_chat

# Copy binaries
cp ollama_chat ~/bin/ollama_chat/
cp web_search ~/bin/ollama_chat/

# Create config file
cat >~/bin/ollama_chat/ollama_explain.conf <<'EOF'
MODEL="ministral-3:8b"
EDITOR=nvim
PAGER=nvim
EOF

# Make executable and add to PATH if needed
chmod +x ~/bin/ollama_chat/ollama_chat
chmod +x ~/bin/ollama_chat/web_search
