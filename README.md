# claude-code-vscode-notifier

Notifications macOS natives pour [Claude Code](https://claude.ai/code) dans VS Code.

Affiche le dernier message de Claude en notification à chaque fin de réponse, via le hook `Stop` de Claude Code.

## Prérequis

- macOS
- Claude Code (extension VS Code)
- Python 3
- `jq` : `brew install jq`

## Installation

### 1. Compiler l'app

```bash
swiftc ClaudeNotifier/main.swift -o ClaudeNotifier
mkdir -p ~/Applications/ClaudeNotifier.app/Contents/MacOS
cp ClaudeNotifier ~/Applications/ClaudeNotifier.app/Contents/MacOS/
cp ClaudeNotifier/Info.plist ~/Applications/ClaudeNotifier.app/Contents/
```

### 2. Installer le hook

```bash
mkdir -p ~/.claude/hooks
cp hooks/notify.sh ~/.claude/hooks/notify.sh
chmod +x ~/.claude/hooks/notify.sh
```

### 3. Configurer Claude Code

Ajouter dans `~/.claude/settings.json` :

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/VOTRE_NOM/.claude/hooks/notify.sh"
          }
        ]
      }
    ]
  }
}
```

Remplacer `VOTRE_NOM` par votre nom d'utilisateur macOS.

### 4. Autoriser les notifications

Au premier lancement, macOS demandera l'autorisation d'afficher des notifications pour "Claude Code". Accepter.

## Désinstallation

```bash
rm -rf ~/Applications/ClaudeNotifier.app
rm ~/.claude/hooks/notify.sh
```

Supprimer le bloc `Stop` dans `~/.claude/settings.json`.
