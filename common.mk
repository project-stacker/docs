# Safe shell flags (https://sipb.mit.edu/doc/safe-shell/)
SHELL := bash
.SHELLFLAGS := -euf -o pipefail -c

# Enable verbosity by setting V=1
E=@echo
ifeq ($(V),1)
Q=
else
Q=@
endif

# Comma separated list from files
null  :=
space := $(null) #
comma := ,

comma_separated = $(subst $(space),$(comma),$(strip $(1)))

# Determine Operating System
# Not detecting architecture as we don't need that yet.

ifeq ($(OS),Windows_NT)
	detected_os := Windows
else
    detected_os := $(shell uname -s)
endif

is_windows =$(filter Windows,$(detected_os))
is_linux   =$(filter Linux,$(detected_os))
is_darwin  =$(filter Darwin,$(detected_os))

# Not supporting windows currently, TODO: implement `where` support
cmd_linux   =command -v $(1) 2>&1
cmd_darwin  =$(call cmd_linux,$(1))

define cmd
$(if $(is_linux),$(shell $(call cmd_linux,$(1))),$(if $(is_darwin),$(shell $(call cmd_darwin,$(1))),))
endef

define cmd_ensure_exists
$(if $(call cmd,$(1)),,@echo "$(1) not available, please install it"; exit 1)
endef

define open_browser_not_supported
echo "cut and paste $(1) into your web browser";
endef

define open_browser_nix
$(Q) if command -v sensible-browser &> /dev/null ; then \
	sensible-browser "$(1)"; \
elif command -v xdg-open &> /dev/null ; then \
	xdg-open "$(1)"; \
elif command -v open &> /dev/null ; then \
	open "$(1)"; \
else \
	$(open_browser_not_supported) \
fi
endef

# TODO: add support for Windows CMD and PowerShell shells.
define open_browser_win
@$(open_browser_not_supported,$(1))
endef

define open_browser
$(if $(is_windows),$(call open_browser_win,$(1)),$(call open_browser_nix,$(1)))
endef