# claude-code-vscode-notifier

Notifications macOS pour Claude Code (VS Code) qui affichent **le contenu du dernier message** — pas juste "Task completed".

```
Claude Code
"Voici les fichiers modifiés : auth.ts, user.servic…"
```

## Prérequis

- macOS
- Claude Code (extension VS Code)
- Xcode Command Line Tools : `xcode-select --install`

## Installation

```bash
brew tap nicolasclaisse/tap
brew install claude-code-vscode-notifier
```

Le setup configure automatiquement le hook dans `~/.claude/settings.json`.

## Comment ça marche

À chaque fin de réponse, le hook `Stop` de Claude Code lit le transcript de la session et extrait le dernier message assistant pour l'afficher en notification native macOS. Si le message se termine par une question, la notification est préfixée par "Attends ton input".

Aucune dépendance externe — uniquement bash, sed et grep natifs macOS.

## Désinstallation

```bash
brew uninstall claude-code-vscode-notifier
```

Supprimer le bloc `Stop` dans `~/.claude/settings.json`.
