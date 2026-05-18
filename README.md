# Bash Stuffs

> A miscellaneous collection of bash stuff -- including custom aliases, Zsh theme, and a CLI AI assistant.

**Personal, only-for-fun project!** Don't take it too seriously, but feel free to open issues or PRs ;)

---

## Setup

Clone the repository and source it from your shell config:

```bash
git clone git@github.com:nevesbruno/bash-stuffs.git ~/lab/bash-stuffs
echo "[ -f ~/lab/bash-stuffs/alias.sh ] && source ~/lab/bash-stuffs/alias.sh" >> ~/.zshrc
```

### Oh-My-Zsh Theme

```bash
cp ~/lab/bash-stuffs/tuntz.zsh-theme ~/.oh-my-zsh/themes/tuntz.zsh-theme
# Then set ZSH_THEME="tuntz" in ~/.zshrc
```

---

## Project Structure

```
.
├── alias.sh                          # Main aliases & functions loader
├── tuntz.zsh-theme                    # Oh-My-Zsh theme
├── .config/ai-alias/
│   ├── modules/
│   │   └── ai-alias-cli.sh           # AI Alias CLI module (DeepSeek)
│   └── backups/                      # Auto-backups before AI writes
├── VERSION
└── README.md
```

---

## Modules

### AI Alias CLI (`ai-alias`)

CLI that creates shell aliases and functions via Artificial Intelligence (DeepSeek).

**Dependencies:** `curl`, `jq`

**Setup:**
```bash
mkdir -p ~/.config/ai-alias
echo 'DEEPSEEK_API_KEY="sk-your-key-here"' > ~/.config/ai-alias/env
```

**Usage:**
```bash
ai-alias                          # Interactive mode
ai-alias -p "description"         # Direct mode
ai-alias -p "description" --preview  # Preview only
ai-alias -p "description" --force    # Skip confirmation
ai-alias -h                        # Full help
```

> The full module code is at `~/.config/ai-alias/modules/ai-alias-cli.sh`.
> It's also versioned inside the repo at `.config/ai-alias/modules/ai-alias-cli.sh`.

---

## Included Aliases & Functions

### General

| Alias | Description |
|-------|-------------|
| `ws` | `cd ~/workspace` |
| `c` | `clear` |
| `cl` | `clear && ls -lha` |
| `bashedit` | `vi ~/.zshrc` |
| `a` / `valias` | `vim ~/lab/bash-stuffs/alias.sh` |
| `hosts` | `sudo vim /etc/hosts` |
| `chosts` | `cat /etc/hosts` |

### Git

| Alias / Function | Description |
|------------------|-------------|
| `gst` | `git status` |
| `gbranch` | `git branch` |
| `glog` | Formatted git log (last 20 commits) |
| `gdiff` | `git diff` |
| `gcp` | `git cherry-pick` |
| `gstq` | `git status --short` with `grep modified` |
| `gfind` | Search commits by author, date, or message |
| `clone-lnv` | Clone with a specific SSH key |
| `cmt` | `git add . && git commit -m "message"` |

### Docker

| Alias | Description |
|-------|-------------|
| `dps` | `docker ps` |
| `dpsa` | `docker ps -a` |
| `dbash` | `docker exec -it <container> bash` |
| `drm` | `docker rm <container>` |
| `dexec` | `docker exec -it <container> <command>` |

### Drupal / Lando (Sanepar portal)

| Alias / Function | Description |
|------------------|-------------|
| `lstart`/`lstop`/`lrestart`/`lstatus` | Lando lifecycle |
| `ldrush` | Lando drush wrapper |
| `lcr` | `lando drush cr` |
| `portalcliente-fetch-prod` | Sync DB/files from production |
| `portalcliente-fetch-dev` | Sync DB/files from development |
| `portalcliente-refresh` | Full refresh from production |
| `portalcliente-refresh-from-dev` | Full refresh from development |
| `portalcliente-import-config` | Drupal config import |
| `ss-import`/`ss-export` | Site Studio package helpers |

### Utilities

| Alias / Function | Description |
|------------------|-------------|
| `mountGdrive` | Mount G: drive on WSL |
| `getOff` | Shutdown WSL |
| `clear-npm` | Clean & reinstall npm dependencies |
| `mkcd` | Create dir + `docs/` subdir and cd into it |
| `venv` | Activate Python virtualenv |
| `nrd` | `npm run dev` |
| `play` | Open VS Code + `npm run dev` |

---

## Versioning

See `VERSION` file for the current version.

---

## License

MIT -- do whatever you want with it.
