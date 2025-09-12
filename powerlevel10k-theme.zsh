source "${0:A:h}/external/powerlevel10k/powerlevel10k.zsh-theme"

for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
  eval $COLOR='%{$fg[${(L)COLOR}]%}'
  eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
#eval $BRIGHT_RED='%{$fg_bold[(L)red]%}'
#eval $BRIGHT_GREEN='%{$fg_bold[$green]%}'
#eval $BRIGHT_YELLOW='%{$fg_bold[yellow]%}'
#eval $BRIGHT_BLUE='%{$fg_bold[blue]%}'
#eval $BRIGHT_PURPLE='%{$fg_bold[magenta]%}'
#eval $BRIGHT_CYAN='%{$fg_bold[cyan]%}'
NEWLINE=$'\n'
eval RESET='%{$reset_color%}'

# Config file for Powerlevel10k with the style of Pure (https://github.com/sindresorhus/pure).
#
# Differences from Pure:
#
#   - Git:
#     - `@c4d3ec2c` instead of something like `v1.4.0~11` when in detached HEAD state.
#     - No automatic `git fetch` (the same as in Pure with `PURE_GIT_PULL=0`).
#
# Apart from the differences listed above, the replication of Pure prompt is exact. This includes
# even the questionable parts. For example, just like in Pure, there is no indication of Git status
# being stale; prompt symbol is the same in command, visual and overwrite vi modes; when prompt
# doesn't fit on one line, it wraps around with no attempt to shorten it.
#
# If you like the general style of Pure but not particularly attached to all its quirks, type
# `p10k configure` and pick "Lean" style. This will give you slick minimalist prompt while taking
# advantage of Powerlevel10k features that aren't present in Pure.

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  autoload -Uz is-at-least && is-at-least 5.1 || return

  # Prompt colors.
  local grey=242
  local red=1
  local yellow=3
  local blue=4
  local magenta=5
  local cyan=6
  local white=7

  local prompt_foreground=$magenta

  # Left prompt segments.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    context                   # user@host
    dir                       # current directory
    vcs                       # git status
    asdf                      # rtx
    command_execution_time    # previous command duration
    # =========================[ Line #2 ]=========================
    newline                   # \n
    virtualenv                # python virtual environment
    background_jobs
    prompt_char               # prompt symbol
  )

  # Right prompt segments.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    # command_execution_time  # previous command duration
    # virtualenv              # python virtual environment
    # context                 # user@host
    # time                    # current time
    # =========================[ Line #2 ]=========================
    newline                   # \n
  )

  # Basic style options that define the overall prompt look.
  typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=           # no segment icons

  # Add an empty line before each prompt except the first. This doesn't emulate the bug
  # in Pure that makes prompt drift down whenever you use the Alt-C binding from fzf or similar.
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # Magenta prompt symbol if the last command succeeded.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=$blue
  # Red prompt symbol if the last command failed.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=$red
  # Default prompt symbol.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  # Prompt symbol in command vi mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  # Prompt symbol in visual vi mode is the same as in command mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='❮'
  # Prompt symbol in overwrite vi mode is the same as in command mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false

  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
  # Background jobs color.
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=3
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='✦'

  # Grey Python Virtual Environment.
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$grey
  # Don't show Python version.
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  # Blue current directory.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$prompt_foreground

  # Context format when root: user@host. The first part white, the rest grey.
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="%F{$white}%n%f%F{$grey}@%m%f"
  # Context format when not root: user@host. The whole thing grey.
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="%F{$grey}%n@%m%f"
  # Don't show context unless root or in SSH.
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION=

  # Show previous command duration only if it's >= 5s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
  # Don't show fractional seconds. Thus, 7s rather than 7.3s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  # Duration format: 1d 2h 3m 4s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  # Yellow previous command duration.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$cyan

  #####################################[ vcs: git status ]######################################
  # Branch icon. Set this parameter to '\uF126 ' for the popular Powerline branch icon.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=

  # Untracked files icon. It's really a question mark, your font isn't broken.
  # Change the value of this parameter to show a different icon.
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  # Formatter for Git status.
  #
  # Example output: master wip ⇣42⇡42 *42 merge ~42 +42 !42 ?42.
  #
  # You can edit the function to customize how Git status looks.
  #
  # VCS_STATUS_* parameters are set by gitstatus plugin. See reference:
  # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh.
  function my_git_formatter() {
    emulate -L zsh
    typeset -g  GITSTATUS_PROMPT=''
    typeset -gi GITSTATUS_PROMPT_LEN=0

    local       name=$CYAN
    local      clean=$MAGENTA
    local   modified=$GREEN
    local  untracked=$GREEN
    local conflicted=$RED
    local        num=${PROMPT_DISPLAY_STATS_NUM:-0}
    local     prefix
    if [ $PROMPT_PREFIX ]; then
      prefix=$PROMPT_PREFIX
    fi

    local p="$prefix"

    local where  # branch name, tag or commit
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      where=$VCS_STATUS_LOCAL_BRANCH
    elif [[ -n $VCS_STATUS_TAG ]]; then
      p+="%f${PROMPT_TAG_PREFIX}"
      where=$VCS_STATUS_TAG
    else
      p+="%f${PROMPT_COMMIT_PREFIX}"
      where=${VCS_STATUS_COMMIT[1,8]}
    fi

    (( $#where > 32 )) && where[13,-13]="…"          # truncate long branch names and tags
    p+="${name}$PROMPT_WHERE_COLOR${where//\%/%%}"     # escape %

    local COMMITS_BEHIND=$VCS_STATUS_COMMITS_BEHIND
    local COMMITS_AHEAD=$VCS_STATUS_COMMITS_AHEAD
    local PUSH_COMMITS_BEHIND=$VCS_STATUS_PUSH_COMMITS_BEHIND
    local PUSH_COMMITS_AHEAD=$VCS_STATUS_PUSH_COMMITS_AHEAD
    local STASHES=$VCS_STATUS_STASHES
    local NUM_CONFLICTED=$VCS_STATUS_NUM_CONFLICTED
    local NUM_STAGED=$VCS_STATUS_NUM_STAGED
    local NUM_UNSTAGED=$VCS_STATUS_NUM_UNSTAGED
    local NUM_UNTRACKED=$VCS_STATUS_NUM_UNTRACKED
    local SPACE=' '
    if [ "$num" = "0" ]; then
      COMMITS_BEHIND=''
      COMMITS_AHEAD=''
      PUSH_COMMITS_BEHIND=''
      PUSH_COMMITS_AHEAD=''
      STASHES=''
      NUM_CONFLICTED=''
      NUM_STAGED=''
      NUM_UNSTAGED=''
      NUM_UNTRACKED=''
      SPACE=''
    fi

    local SPACE_MOD=$(( VCS_STATUS_NUM_CONFLICTED || VCS_STATUS_NUM_STAGED || VCS_STATUS_NUM_UNSTAGED || VCS_STATUS_NUM_UNTRACKED ))
    local IS_CHANGE=$SPACE_MOD

    local DISPLAY_STATS_REMOTE=${PROMPT_DISPLAY_STATS_REMOTE:=1}
    local DISPLAY_STATS_STASH=${PROMPT_DISPLAY_STATS_STASH:=1}
    local DISPLAY_STATS_ACTION=${PROMPT_DISPLAY_STATS_ACTION:=1}
    local UNI_CHANGE_MODE=${PROMPT_UNI_CHANGE_MODE:=0}

    if [ $DISPLAY_STATS_REMOTE = 1 ]; then
      # ⇣42 if behind the remote.
      (( VCS_STATUS_COMMITS_BEHIND )) && p+=" ${clean}⇣${COMMITS_BEHIND}"
      # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
      (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
      (( VCS_STATUS_COMMITS_AHEAD  )) && p+="${clean}⇡${COMMITS_AHEAD}"
      # ⇠42 if behind the push remote.
      (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ${clean}⇠${PUSH_COMMITS_BEHIND}"
      (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" "
      # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
      (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && p+="${clean}⇢${PUSH_COMMITS_AHEAD}"
    fi

    if [ $DISPLAY_STATS_STASH = 1 ];then
      # *42 if have stashes.
      (( VCS_STATUS_STASHES        )) && p+=" ${clean}*${STASHES}"
    fi

    if [ $DISPLAY_STATS_ACTION = 1 ];then
      [[ -n $VCS_STATUS_ACTION     ]] && p+=" ${conflicted}${VCS_STATUS_ACTION}"
    fi

    if [ $UNI_CHANGE_MODE = 1 ] && [ $IS_CHANGE = 1 ]; then
      UNI_CHAR=${PROMPT_UNI_MODE_CHAR:-"*"}
      [ ! $PROMPT_UNI_MODE_EMPTY = 1 ] && p+="$UNI_CHAR"
    else
      # add additional space if there are uncommitted changes
      (( SPACE_MOD && !num         )) && p+=" "

      # ~42 if have merge conflicts.
      (( VCS_STATUS_NUM_CONFLICTED )) && p+="${SPACE}${conflicted}${PROMPT_ICON_CONFLICTED:=~}${NUM_CONFLICTED}"
      # +42 if have staged changes.
      (( VCS_STATUS_NUM_STAGED     )) && p+="${SPACE}${modified}${PROMPT_ICON_STAGED:=+}${NUM_STAGED}"
      # !42 if have unstaged changes.
      (( VCS_STATUS_NUM_UNSTAGED   )) && p+="${SPACE}${modified}${PROMPT_ICON_UNSTAGED:=!}${NUM_UNSTAGED}"
      # ?42 if have untracked files. It's really a question mark, your font isn't broken.
      (( VCS_STATUS_NUM_UNTRACKED  )) && p+="${SPACE}${untracked}${PROMPT_ICON_UNTRACKED:=?}${NUM_UNTRACKED}"
    fi

    GITSTATUS_PROMPT="${p}%f${PROMPT_POSTFIX}"

    # The length of GITSTATUS_PROMPT after removing %f and %F.
    GITSTATUS_PROMPT_LEN="${(m)#${${GITSTATUS_PROMPT//\%\%/x}//\%(f|<->F)}}"

    typeset -g my_git_format=$GITSTATUS_PROMPT
  }
  functions -M my_git_formatter 2>/dev/null

  # Don't count the number of unstaged, untracked and conflicted files in Git repositories with
  # more than this many files in the index. Negative value means infinity.
  #
  # If you are working in Git repositories with tens of millions of files and seeing performance
  # sagging, try setting POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY to a number lower than the output
  # of `git ls-files | wc -l`. Alternatively, add `bash.showDirtyState = false` to the repository's
  # config: `git config bash.showDirtyState false`.
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

  # Don't show Git status in prompt for repositories whose workdir matches this pattern.
  # For example, if set to '~', the Git repository at $HOME/.git will be ignored.
  # Multiple patterns can be combined with '|': '~(|/foo)|/bar/baz/*'.
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

  # Disable the default Git status formatting.
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  # Install our own Git status formatter.
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter()))+${my_git_format}}'
  # Enable counters for staged, unstaged, etc.
  typeset -g POWERLEVEL9K_VCS_{STASHES,STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=1

  # Custom icon.
  # typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='⭐'
  # Custom prefix.
  typeset -g POWERLEVEL9K_VCS_PREFIX='%fon '

  # Show status of repositories of these types. You can add svn and/or hg if you are
  # using them. If you do, your prompt may become slow even when your current directory
  # isn't in an svn or hg reposotiry.
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  # Grey current time.
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$grey
  # Format for the current time: 09:51:02. See `man 3 strftime`.
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  # If set to true, time will update when you hit enter. This way prompts for the past
  # commands will contain the start times of their commands rather than the end times of
  # their preceding commands.
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  # Transient prompt works similarly to the builtin transient_rprompt option. It trims down prompt
  # when accepting a command line. Supported values:
  #
  #   - off:      Don't change prompt when accepting a command line.
  #   - always:   Trim down prompt when accepting a command line.
  #   - same-dir: Trim down prompt when accepting a command line unless this is the first command
  #               typed after changing current working directory.
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  # Instant prompt mode.
  #
  #   - off:     Disable instant prompt. Choose this if you've tried instant prompt and found
  #              it incompatible with your zsh configuration files.
  #   - quiet:   Enable instant prompt and don't print warnings when detecting console output
  #              during zsh initialization. Choose this if you've read and understood
  #              https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt.
  #   - verbose: Enable instant prompt and print a warning when detecting console output during
  #              zsh initialization. Choose this if you've never tried instant prompt, haven't
  #              seen the warning, or if you are unsure what this all means.
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
  # For example, you can type POWERLEVEL9K_BACKGROUND=red and see your prompt turn red. Hot reload
  # can slow down prompt by 1-2 milliseconds, so it's better to keep it turned off unless you
  # really need it.
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # If p10k is already loaded, reload configuration.
  # This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
  (( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'

source "${0:A:h}/powerlevel10k-mise.zsh"
