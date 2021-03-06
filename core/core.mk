include mk/cleanvars.mk

# Set current submodule (used for module specific flags compile result etc)
sm := core
sm-$(sm) := y

arch-dir	:= core/arch/$(ARCH)
platform-dir	:= $(arch-dir)/plat-$(PLATFORM)
include $(platform-dir)/conf.mk

cppflags$(sm)	+= -Icore/include $(platform-cppflags) $(core-platform-cppflags)
cflags$(sm)	+= $(platform-cflags) $(core-platform-cflags)
aflags$(sm)	+= $(platform-aflags) $(core-platform-aflags)

# Config flags from mk/config.mk
cppflags$(sm) += -DCFG_TEE_TA_LOG_LEVEL=$(CFG_TEE_TA_LOG_LEVEL)
cppflags$(sm) += -DCFG_TEE_FW_DEBUG=$(CFG_TEE_FW_DEBUG)
cppflags$(sm) += -DCFG_TEE_CORE_LOG_LEVEL=$(CFG_TEE_CORE_LOG_LEVEL)
cppflags$(sm) += -DCFG_TEE_CORE_DYNAMIC_SUPPORT=$(CFG_TEE_CORE_DYNAMIC_SUPPORT)

cppflags$(sm)	+= -Ilib/libutee/include

#
# Do libraries
#

# Set a prefix to avoid conflicts with user TAs that will use the same
# source but with different flags below
base-prefix := $(sm)-
libname = utils
libdir = lib/libutils
include mk/lib.mk

libname = mpa
libdir = lib/libmpa
include mk/lib.mk
base-prefix :=

libname = tomcrypt
libdir = core/lib/libtomcrypt
include mk/lib.mk

#
# Do main source
#
subdirs = $(core-platform-subdirs) core
include mk/subdir.mk
include mk/compile.mk
include $(platform-dir)/link.mk


