BUILD_DIR ?= /tmp/rpi-boot
DISTR_DIR ?= $(CURDIR)/distrib

.PHONY: all
all: firmware armstubs u-boot linux config.txt

include Makefile.pieeprom
include Makefile.firmware
include Makefile.armstubs
include Makefile.u-boot
include Makefile.linux

.PHONY: config.txt
config.txt:
	@if [ ! -f "$(DISTR_DIR)/config.txt" ]; then \
		echo "################################################################################"; \
		echo "# Generate: $(DISTR_DIR)/config.txt"; \
		echo "################################################################################"; \
		{ \
			echo '[pi3]'; \
			echo 'arm_64bit=1'; \
			echo 'kernel=u-boot-rpi3-arm64.bin'; \
			echo 'dtoverlay=miniuart-bt'; \
			echo 'dtoverlay=vc4-kms-v3d'; \
			echo '[pi4]'; \
			echo 'arm_64bit=1'; \
			echo 'kernel=u-boot-rpi4-arm64.bin'; \
			echo 'dtoverlay=miniuart-bt'; \
			echo 'dtoverlay=vc4-kms-v3d'; \
			echo '[all]'; \
			echo 'force_turbo=1'; \
			echo 'disable_overscan=1'; \
		} > "$(DISTR_DIR)/config.txt"; \
	fi

.PHONY: clean
clean:
	@find "$(DISTR_DIR)" -mindepth 1 -maxdepth 1 -type d | xargs rm -fr
	@find "$(DISTR_DIR)" -mindepth 1 -maxdepth 1 -type f -not -name ".gitkeep" | xargs rm -f
	@rm -fr "$(BUILD_DIR)/u-boot"
	@rm -fr "$(BUILD_DIR)/linux"
