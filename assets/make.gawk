#!/usr/bin/env -S gawk -f

BEGIN {
  # the field seperator should be able to 
  # seperate fields for any of the pattern
  # below. Options, commands and targets.
  FS="(:.*##|?=)";

  printf "\n\033[1mUsage:\033[0m\n  make \033[36m[ COMMAND ]"
  printf "\033[0m \33[35m[ OPTION=VALUE ]...\33[0m\n"
}

# match variables ( name ?= default)
/^[a-zA-Z_]+\s\?=.*/ {
  printf "  \033[35m%-20s\033[0m (default:%s)\n", $1, $2
}

# match headings (##@ <heading>)
/^##@/ {
  printf "\n\033[1m%s:\033[0m\n", substr($0, 5)
}

# match sub-headings (###@ <heading>)
/^###@/ {
  printf "\n\033[0m%s:\033[0m\n", substr($0, 6)
}

# match targets with description (target: ## <description>)
/^[a-zA-Z_0-9\-\/]+:.*?##/ {
  printf "  \033[36m%-20s\033[0m %s\n", $1, $2
}
