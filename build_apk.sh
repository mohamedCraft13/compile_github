#!/bin/bash

# 1. Check for GitHub CLI (gh)
if ! command -v gh &> /dev/null; then
    echo "[-] GitHub CLI not found. Installing..."
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install gh -y
    echo "[+] GitHub CLI installed. Please run 'gh auth login' after this script finishes if it fails."
fi

# 2. Sync changes to GitHub
echo "[+] Syncing files to GitHub..."
git add .
git commit -m "Build trigger: $(date)"
git push

# 3. Trigger the Workflow
echo "[+] Triggering GitHub Action build..."
gh workflow run build.yml
sleep 10  # Wait for GitHub to register the run

# 4. Get the latest Run ID
RUN_ID=$(gh run list --workflow="build.yml" --limit 1 --json databaseId --jq '.[0].databaseId')

if [ -z "$RUN_ID" ]; then
    echo "[!] Could not find the run ID. Check your internet connection."
    exit 1
fi

echo "[+] Watching Build ID: $RUN_ID"
echo "[!] This will take 15-20 minutes. Please wait..."

# 5. Watch the build
gh run watch $RUN_ID

# 6. Download the APK
echo "[+] Build finished! Downloading APK..."
gh run download $RUN_ID --name kivy-apk --dir ./output_apk

echo "[SUCCESS] Your APK is in the 'output_apk' folder!"
