#!/usr/bin/env bash
#
# ai-alias-cli.sh - Módulo da CLI Inteligente de Aliases (DeepSeek)
#
# Criado automaticamente a partir do alias.sh
# Uso: source ~/.config/ai-alias/modules/ai-alias-cli.sh
#
# Dependências: curl, jq, chave de API da DeepSeek configurada em
#               ~/.config/ai-alias/env (DEEPSEEK_API_KEY="sk-...")
#
# Funções exportadas:
#   ai-alias               - CLI principal para criar aliases/funções com IA
#   __ai_ensure_dirs       - Garante estrutura de diretórios
#   __ai_load_env          - Carrega variáveis de ambiente (API Key)
#   __ai_save_history      - Salva histórico de criação
#   __ai_backup_aliases    - Cria backup dos arquivos de aliases
#

# --- Configurações ---
AI_ALIAS_DIR="${AI_ALIAS_DIR:-$HOME/.config/ai-alias}"
AI_ALIAS_ENV="$AI_ALIAS_DIR/env"
AI_ALIAS_HISTORY="$AI_ALIAS_DIR/history"
AI_ALIAS_MODULES_DIR="$AI_ALIAS_DIR/modules"
AI_ALIAS_BACKUP_DIR="$AI_ALIAS_DIR/backups"

# Garante estrutura de diretórios
__ai_ensure_dirs() {
    mkdir -p "$AI_ALIAS_DIR" "$AI_ALIAS_MODULES_DIR" "$AI_ALIAS_BACKUP_DIR"
}

# Carrega variáveis de ambiente (API Key)
__ai_load_env() {
    __ai_ensure_dirs
    if [ -f "$AI_ALIAS_ENV" ]; then
        source "$AI_ALIAS_ENV"
    else
        echo "⚠️  Arquivo de configuração não encontrado: $AI_ALIAS_ENV"
        echo "Crie o arquivo com:"
        echo "  echo 'DEEPSEEK_API_KEY=\"sk-sua-chave-aqui\"' > $AI_ALIAS_ENV"
        return 1
    fi

    if [ -z "$DEEPSEEK_API_KEY" ]; then
        echo "❌ DEEPSEEK_API_KEY não definida em $AI_ALIAS_ENV"
        return 1
    fi
}

# Salva histórico de criação
__ai_save_history() {
    local tipo="$1"
    local nome="$2"
    local descricao="$3"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp | $tipo | $nome | $descricao" >> "$AI_ALIAS_HISTORY"
}

# Cria backup do alias.sh antes de modificar
__ai_backup_aliases() {
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$AI_ALIAS_BACKUP_DIR/zshrc_backup_$timestamp"
    fi
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$AI_ALIAS_BACKUP_DIR/bashrc_backup_$timestamp"
    fi
    # Faz backup do próprio alias.sh se existir
    local script_path
    script_path="$(realpath "${BASH_SOURCE[0]:-$0}" 2>/dev/null || echo "$HOME/lab/bash-stuffs/alias.sh")"
    if [ -f "$script_path" ]; then
        cp "$script_path" "$AI_ALIAS_BACKUP_DIR/alias_backup_$timestamp.sh"
    fi
}

# --- Interface CLI Principal ---

ai-alias() {
    local prompt=""
    local preview=false
    local force=false
    local model="deepseek-chat"

    # Processa flags
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -p|--prompt) prompt="$2"; shift 2 ;;
            -v|--preview) preview=true; shift ;;
            -f|--force) force=true; shift ;;
            -m|--model) model="$2"; shift 2 ;;
            -h|--help)
                echo -e "${CYAN}╔══════════════════════════════════════════════╗${RESET}"
                echo -e "${CYAN}║${RESET}  🧠 ${YELLOW}ai-alias${RESET} - Criador Inteligente de Aliases ${CYAN}║${RESET}"
                echo -e "${CYAN}╚══════════════════════════════════════════════╝${RESET}"
                echo ""
                echo -e "${GREEN}Uso:${RESET}"
                echo "  ai-alias                          # Modo interativo"
                echo "  ai-alias -p \"descrição\"            # Modo direto"
                echo "  ai-alias -p \"descrição\" --preview   # Apenas preview"
                echo "  ai-alias -p \"descrição\" --force     # Pula confirmações"
                echo ""
                echo -e "${YELLOW}Flags:${RESET}"
                echo "  -p, --prompt   Descreva o alias/função que precisa"
                echo "  -v, --preview  Mostra o código gerado sem aplicar"
                echo "  -f, --force    Aplica sem confirmação"
                echo "  -m, --model    Modelo DeepSeek (padrão: deepseek-chat)"
                echo "  -h, --help     Mostra esta ajuda"
                echo ""
                echo -e "${CYAN}Exemplos:${RESET}"
                echo '  ai-alias'
                echo '  ai-alias -p "alias para listar commits grandes (>10 arquivos)"'
                echo '  ai-alias -p "funcao para criar branch com data no nome" --preview'
                return 0
                ;;
            *) prompt="$1"; shift ;;
        esac
    done

    # Cores
    local CYAN='\033[1;36m'
    local GREEN='\033[1;32m'
    local YELLOW='\033[1;33m'
    local RED='\033[1;31m'
    local MAGENTA='\033[1;35m'
    local BLUE='\033[1;34m'
    local BOLD='\033[1m'
    local RESET='\033[0m'

    # Se não veio prompt via flag, entra em modo interativo
    if [ -z "$prompt" ]; then
        clear
        echo -e "${CYAN}╔══════════════════════════════════════════════════╗${RESET}"
        echo -e "${CYAN}║${RESET}        🧠  ${BOLD}AI ALIAS - Assistente de Automação${RESET}  ${CYAN}║${RESET}"
        echo -e "${CYAN}╚══════════════════════════════════════════════════╝${RESET}"
        echo ""
        echo -e "${GREEN}Descreva o que você precisa automatizar:${RESET}"
        echo -e "${YELLOW}Exemplo:${RESET} 'quero um alias para abrir o VS Code direto na branch atual'"
        echo -e "${YELLOW}Exemplo:${RESET} 'funcao para fazer deploy para produção com confirmacao'"
        echo -e "${YELLOW}Exemplo:${RESET} 'alias para limpar branches locais que não existem mais no remoto'"
        echo ""
        echo -ne "${CYAN}➜ ${RESET}"
        read -r prompt
        echo ""

        if [ -z "$prompt" ]; then
            echo -e "${RED}❌ Nenhuma descrição informada. Cancelando.${RESET}"
            return 1
        fi
    fi

    # Carrega API key
    __ai_load_env || return 1

    # Extrai contexto do arquivo de aliases atual (últimas 30 linhas ou seções relevantes)
    local context=""
    local script_path
    script_path="$(realpath "${BASH_SOURCE[0]:-$0}" 2>/dev/null || echo "")"
    if [ -n "$script_path" ] && [ -f "$script_path" ]; then
        context=$(head -150 "$script_path" 2>/dev/null | grep -E "^(function|alias)" | head -20)
    fi

    # Monta prompt para DeepSeek
    local system_prompt
    system_prompt=$(cat << 'SYSTEM'
Você é o AI Alias, um especialista em Shell Script (bash/zsh) especializado em criar aliases, funções e módulos shell.

## REGRAS ABSOLUTAS:
1. Gere APENAS código shell válido, sem markdown, sem explicações, sem bloco de código.
2. Saída deve ser **puramente código executável**.
3. Para aliases simples: use o formato `alias nome="comando"`.
4. Para funções: use `function nome(){ ... }`.
5. Quando o comando for mais complexo (mais de 3 linhas ou com muita lógica), crie UM ARQUIVO separado em ~/.config/ai-alias/modules/ e adicione um source no arquivo principal.

## FORMATO DE SAÍDA:
Seu output deve começar com um marcador indicando o tipo e posição:
- Se for ALIAS:  "ALIAS|nome_do_alias|comando"
- Se for FUNCTION (inline): "FUNCTION|nome_da_funcao|codigo_da_funcao"
- Se for MODULE (arquivo separado): "MODULE|nome_do_modulo|conteudo_do_arquivo|source_comando"

## ORGANIZAÇÃO:
- Aliases de git: prefixo `g`
- Aliases de docker: prefixo `d`
- Aliases de npm: prefixo `n`
- Aliases de projeto: nome descritivo sem prefixo
- Funções utilitárias: prefixo `__` para internas

## DIRETÓRIO DE MÓDULOS:
Módulos (arquivos) devem ser salvos em: ~/.config/ai-alias/modules/

## EXEMPLOS DE SAÍDA (para prompt "alias para ver diff colorido com stat"):
ALIAS|gdiffc|git diff --stat --color=always | less -R

## EXEMPLO PARA FUNÇÃO MAIS COMPLEXA (prompt: "funcao para criar branch com data"):
FUNCTION|branch-date|
function branch-date() {
    local branch_name="${1:-feature}"
    local date_suffix
    date_suffix=$(date +"%Y%m%d")
    git checkout -b "${branch_name}-${date_suffix}"
    echo "✅ Branch criada: ${branch_name}-${date_suffix}"
}

## EXEMPLO PARA MÓDULO EXTERNO (prompt: "função complexa para deploy"):
MODULE|deploy|
function deploy() {
    local env="${1:-production}"
    echo "🚀 Deploying to $env..."
    git pull origin main
    npm run build
    npm run test
    echo "✅ Deploy concluído para $env!"
}|
source ~/.config/ai-alias/modules/deploy.sh

## IMPORTANTE:
- Sempre use 'function' para funções (não apenas nome() )
- Inclua validações básicas (verificar se argumento foi passado)
- Adicione mensagens coloridas com echo
- Para módulos: o arquivo deve conter APENAS a função, sem comentários desnecessários
- Retorne código funcional e idiomático shell
SYSTEM
)

    local user_prompt="Crie alias/função baseado nesta descrição: \"$prompt\"

Contexto de aliases existentes no arquivo (para referência de estilo):
$context"

    # Mostra status
    echo -e "${CYAN}⚡${RESET} Consultando ${YELLOW}DeepSeek${RESET}..."
    echo ""

    # Chama API DeepSeek
    local response
    response=$(curl -s -w "\n%{http_code}" https://api.deepseek.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $DEEPSEEK_API_KEY" \
        -d "$(cat <<EOF
{
    "model": "$model",
    "messages": [
        {"role": "system", "content": $(echo "$system_prompt" | jq -Rs .)},
        {"role": "user", "content": $(echo "$user_prompt" | jq -Rs .)}
    ],
    "temperature": 0.3,
    "max_tokens": 2000
}
EOF
    )")

    local http_code
    http_code=$(echo "$response" | tail -n1)
    local body
    body=$(echo "$response" | sed '$d')

    # Verifica erro HTTP
    if [ "$http_code" != "200" ]; then
        echo -e "${RED}❌ Erro HTTP $http_code ao chamar API DeepSeek.${RESET}"
        # FIXED: single quote properly closed before the double quote
        echo "$body" | jq -r '.error.message // "Erro desconhecido"' 2>/dev/null || echo "$body"
        return 1
    fi

    # Extrai conteúdo
    local content
    content=$(echo "$body" | jq -r '.choices[0].message.content // empty' 2>/dev/null)

    if [ -z "$content" ]; then
        echo -e "${RED}❌ Resposta vazia da API.${RESET}"
        return 1
    fi

    # Processa a saída gerada
    echo -e "${GREEN}✅ Resposta recebida!${RESET}"
    echo ""

    # Mostra o código gerado
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║${RESET}         📝  ${BOLD}Código Gerado${RESET}               ${CYAN}║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${GREEN}$content${RESET}"
    echo ""

    # Se for apenas preview, para por aqui
    if [ "$preview" = true ]; then
        echo -e "${YELLOW}🔍 Modo preview. Nada foi aplicado.${RESET}"
        return 0
    fi

    # Confirma antes de aplicar (a menos que --force)
    if [ "$force" = false ]; then
        echo -ne "${YELLOW}❓ Deseja aplicar este alias/função? (s/N): ${RESET}"
        read -r confirm
        if [[ ! "$confirm" =~ ^[sSyY]([eE][sS])?$ ]]; then
            echo -e "${RED}✖ Cancelado pelo usuário.${RESET}"
            return 0
        fi
    fi

    # --- Aplica as alterações ---

    __ai_backup_aliases

    # Determina onde escrever
    local target_file
    if [ -f "$HOME/.zshrc" ]; then
        target_file="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        target_file="$HOME/.bashrc"
    else
        target_file="$HOME/.bashrc"
    fi

    local alias_script_path
    alias_script_path="$(realpath "${BASH_SOURCE[0]:-$0}" 2>/dev/null || echo "$HOME/lab/bash-stuffs/alias.sh")"

    # Processa cada linha do output
    local IFS=$'\n'
    local line
    local applied_count=0
    local module_count=0

    for line in $content; do
        # Remove espaços
        line=$(echo "$line" | xargs)

        # Pula linhas vazias
        [ -z "$line" ] && continue

        if echo "$line" | grep -q "^ALIAS|"; then
            # Formato: ALIAS|nome|comando
            local alias_name alias_cmd
            alias_name=$(echo "$line" | cut -d'|' -f2)
            alias_cmd=$(echo "$line" | cut -d'|' -f3-)

            if [ -n "$alias_name" ] && [ -n "$alias_cmd" ]; then
                # Adiciona ao alias.sh
                local alias_line="alias $alias_name=\"$alias_cmd\""
                echo "" >> "$alias_script_path"
                echo "# [AI] $(date +"%Y-%m-%d %H:%M") - $prompt" >> "$alias_script_path"
                echo "$alias_line" >> "$alias_script_path"

                # Adiciona também no .zshrc/.bashrc (source se não existir)
                if ! grep -q "source.*$alias_script_path" "$target_file" 2>/dev/null; then
                    echo "" >> "$target_file"
                    echo "# Carrega aliases personalizados" >> "$target_file"
                    echo "[ -f \"$alias_script_path\" ] && source \"$alias_script_path\"" >> "$target_file"
                fi

                echo -e "${GREEN}✔${RESET} Alias '${CYAN}$alias_name${RESET}' adicionado!"
                __ai_save_history "alias" "$alias_name" "$prompt"
                ((applied_count++))
            fi

        elif echo "$line" | grep -q "^FUNCTION|"; then
            # Formato: FUNCTION|nome|codigo
            local func_name func_code
            func_name=$(echo "$line" | cut -d'|' -f2)
            func_code=$(echo "$line" | cut -d'|' -f3-)

            if [ -n "$func_name" ] && [ -n "$func_code" ]; then
                echo "" >> "$alias_script_path"
                echo "# [AI] $(date +"%Y-%m-%d %H:%M") - $prompt" >> "$alias_script_path"
                echo "$func_code" >> "$alias_script_path"
                echo -e "${GREEN}✔${RESET} Função '${CYAN}$func_name${RESET}' adicionada!"
                __ai_save_history "function" "$func_name" "$prompt"
                ((applied_count++))
            fi

        elif echo "$line" | grep -q "^MODULE|"; then
            # Formato: MODULE|nome|conteudo|source_cmd
            local mod_name mod_content mod_source
            mod_name=$(echo "$line" | cut -d'|' -f2)
            mod_content=$(echo "$line" | cut -d'|' -f3)
            mod_source=$(echo "$line" | cut -d'|' -f4-)

            if [ -n "$mod_name" ] && [ -n "$mod_content" ]; then
                local mod_file="$AI_ALIAS_MODULES_DIR/${mod_name}.sh"
                echo "$mod_content" > "$mod_file"
                chmod +x "$mod_file" 2>/dev/null

                # Adiciona source no alias.sh
                echo "" >> "$alias_script_path"
                echo "# [AI] $(date +"%Y-%m-%d %H:%M") - Módulo: $mod_name" >> "$alias_script_path"
                echo "$mod_source" >> "$alias_script_path"

                echo -e "${GREEN}✔${RESET} Módulo '${CYAN}$mod_name${RESET}' criado em ${BLUE}$mod_file${RESET}"
                __ai_save_history "module" "$mod_name" "$prompt"
                ((applied_count++))
                ((module_count++))
            fi
        fi
    done

    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║${RESET}  ✅ ${GREEN}Finalizado!${RESET} ${applied_count} item(ns) aplicado(s)     ${CYAN}║${RESET}"
    if [ "$module_count" -gt 0 ]; then
        echo -e "${CYAN}║${RESET}  📦 ${module_count} módulo(s) em ${BLUE}$AI_ALIAS_MODULES_DIR${RESET}  ${CYAN}║${RESET}"
    fi
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${RESET}"

    # Recarrega o shell atual
    echo ""
    echo -e "${YELLOW}🔄 Recarregando shell...${RESET}"
    if [ -n "$ZSH_VERSION" ]; then
        source "$HOME/.zshrc" 2>/dev/null
    elif [ -n "$BASH_VERSION" ]; then
        source "$HOME/.bashrc" 2>/dev/null
    fi

    # Carrega o alias.sh também se existir
    [ -f "$alias_script_path" ] && source "$alias_script_path" 2>/dev/null

    echo -e "${GREEN}✅ Pronto! Seu novo alias/função já está disponível.${RESET}"
    echo ""

    # Sugere comandos relacionados
    echo -e "${CYAN}💡 Dica:${RESET} Use ${YELLOW}ai-alias -p \"descricao\"${RESET} para modo direto."
    echo -e "${CYAN}💡 Dica:${RESET} Use ${YELLOW}ai-alias -h${RESET} para ajuda completa."
}
