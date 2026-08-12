.SILENT:
include Makefile.const

define HEADER

:=.                                                      .=:
 :#+.                                                  .+%-
  :#%+                                                =%#:
   .#%#-                                            -#%#.
     *%%#:                                        :#%%*
      #%%%*.                                    .+%%%#
      -%%%%%+.                                 +%%%%%-
      :%%%%%%%+.                            .+%%%%%%%:
      -%%%%%%%%%*=.                      .=*%%%%%%%%%=
      #%%#*++*#%%%%#=.                .=#%%%%#*++*#%%#
     -%*:       .-+%%%*:            :*%%%*-.       .*%=
    :%+        ..   :+#%+.         +%#+:   ..        +%-
    ##          .--    :+#:      :#*:    --.          #%
   -%+            .+-    .=-    -=.    -+.            +%-
   -%=      .:---==-**:              .**-==---:.      =%-
   .%=   .:-%=   %%%%%#-            -#%%%%%   =%-:.   =%:
    *#      =*   :*##+. ::        .: .+##*:   *=      #*
    .#-      =*.       :=          =:       .*=      -#.
      +-       -++=====.            .=====++-       -+
       :-.                                        .-:

                    AthenaEnv project

endef
export HEADER

EE_EXT = .elf

EE_BIN_PREF ?= athena
EE_BIN_PKD = $(EE_BIN_PREF)_pkd

UDPBD ?= 0
ILINK ?= 0
MX4SIO ?= 0

DEBUG ?= 0
EE_SIO ?= 0

PADEMU ?= 1
GRAPHICS ?= 1
ODE_PHYSICS_COLLISION ?= 1
AUDIO ?= 1

# Module linking control
STATIC_KEYBOARD ?= 1
STATIC_MOUSE ?= 1
STATIC_NETWORK ?= 1
STATIC_CAMERA ?= 0

DYNAMIC_KEYBOARD ?= 0
DYNAMIC_MOUSE ?= 0
DYNAMIC_NETWORK ?= 0
DYNAMIC_CAMERA ?= 0

EE_LIBS = -L$(PS2SDK)/ports/lib -Llibs -lmc -lpad -lmtap -lpatches -lz -llzma -lzip -lfileXio -lelf-loader-nocolour -lerl -ldebug -lwolf4sdl -lSDL2main -lSDL2_mixer -lmodplug -lxmp -lSDL2 -laudsrv -latomic[cite: 1]

EE_INCS += -I$(PS2SDK)/ports/include -I$(PS2SDK)/ports/include/zlib -Isrc/readini/include -Isrc/include -Isrc/include/wolf4sdl[cite: 1]

EE_CFLAGS +=  -Wall -fpermissive -DCONFIG_BIGNUM -DCONFIG_VERSION=\"$(shell cat VERSION)\" -D__TM_GMTOFF=tm_gmtoff -DPATH_MAX=256 -DPS2[cite: 1]

ifeq ($(DEBUG),1)
  EE_CFLAGS += -DDEBUG[cite: 1]
endif

JS_CORE = quickjs/cutils.o quickjs/libbf.o quickjs/libregexp.o quickjs/libunicode.o \
				 quickjs/realpath.o quickjs/quickjs.o quickjs/quickjs-libc.o[cite: 1]

VU1_MPGS = draw_3D_colors.o \
           draw_3D_lights.o \
           draw_3D_spec.o \
           draw_3D_colors_skin.o \
           draw_3D_lights_skin.o \
           draw_3D_spec_skin.o \
           draw_3D_lights_ref.o \
           draw_2D_tile_list.o[cite: 1]

# VU0_MPGS = matrix_multiply.o[cite: 1]

APP_CORE = main.o bootlogo.o texture_manager.o owl_packet.o vif.o athena_math.o memory.o ee_tools.o module_system.o iop_manager.o taskman.o lockman.o pad.o system.o strUtils.o mpg_manager.o matrix.o vector.o excepHandler.o exceptions.o [cite: 1]

INI_READER = readini/src/readini.o[cite: 1]

ATHENA_MODULES = ath_env.o ath_vector.o ath_vector4.o ath_matrix.o ath_pads.o ath_system.o ath_iop.o ath_archive.o ath_timer.o ath_task.o ath_mutex.o[cite: 1]

IOP_MODULES = iomanx.o filexio.o sio2man.o mcman.o mcserv.o padman.o  \
			  usbd.o bdm.o bdmfs_fatfs.o usbmass_bd.o cdfs.o \
			  freeram.o ps2dev9.o mtapman.o poweroff.o ps2atad.o \
			  ps2hdd.o ps2fs.o ata_bd.o mmceman.o [cite: 1]

EMBEDDED_ASSETS = quicksand_regular.o owl_indices.o owl_palette.o[cite: 1]

EMBEDDED_ELFS = loader_elf.o[cite: 1]

ifeq ($(UDPBD),1)
  EE_CFLAGS += -DATHENA_UDPBD[cite: 1]
  IOP_MODULES += smap_udpbd.o[cite: 1]
endif

ifeq ($(ILINK),1)
  EE_CFLAGS += -DATHENA_ILINK[cite: 1]
  IOP_MODULES += iLinkman.o IEEE1394_bd.o[cite: 1]
endif

ifeq ($(MX4SIO),1)
  EE_CFLAGS += -DATHENA_MX4SIO[cite: 1]
  IOP_MODULES += mx4sio_bd.o[cite: 1]
endif

ifeq ($(ODE_PHYSICS_COLLISION),1)
  EE_LIBS += -Lee_modules/ode/lib/ -lopcode -lice -lode[cite: 1]
  EE_INCS += -Iee_modules/ode/include[cite: 1]
  EE_CFLAGS += -DATHENA_ODE[cite: 1]

  ATHENA_MODULES += ath_ode.o[cite: 1]

  EXT_LIBS += ee_modules/ode/lib/libice.a ee_modules/ode/lib/libopcode.a ee_modules/ode/lib/libode.a[cite: 1]
endif

ifeq ($(GRAPHICS),1)
  EE_LIBS += -L$(PS2DEV)/gsKit/lib/ -ljpeg -lfreetype -ldmakit -lpng[cite: 1]
  EE_INCS += -I$(PS2DEV)/gsKit/include -I$(PS2SDK)/ports/include/freetype2[cite: 1]
  EE_CFLAGS += -DATHENA_GRAPHICS[cite: 1]
  APP_CORE += tile_render.o graphics.o image_font.o owl_draw.o image_loaders.o mesh_loaders.o atlas.o fntsys.o render.o camera.o skin_math.o calc_3d.o fast_obj/fast_obj.o[cite: 1]

  ATHENA_MODULES += ath_color.o ath_font.o ath_render.o ath_anim_3d.o ath_lights.o ath_3dcamera.o ath_screen.o ath_image.o ath_imagelist.o ath_shape.o ath_shadows.o ath_sprite.o[cite: 1]
  APP_CORE += shadows.o render_batch.o render_scene.o render_async_loader.o[cite: 1]
  EE_OBJS += $(VU1_MPGS) $(VU0_MPGS)[cite: 1]
endif

ifeq ($(PADEMU),1)
  EE_CFLAGS += -DATHENA_PADEMU[cite: 1]
  EE_INCS += -Iiop_modules/ds34bt/ee -Iiop_modules/ds34usb/ee[cite: 1]
  EE_LIBS += -Liop_modules/ds34bt/ee/ -Liop_modules/ds34usb/ee/ -lds34bt -lds34usb[cite: 1]
  IOP_MODULES += ds34usb.o ds34bt.o[cite: 1]
	EXT_LIBS += iop_modules/ds34usb/ee/libds34usb.a iop_modules/ds34bt/ee/libds34bt.a[cite: 1]
endif

ifeq ($(AUDIO),1)
  EE_CFLAGS += -DATHENA_AUDIO[cite: 1]
  APP_CORE += sound_sfx.o sound_stream.o[cite: 1]
  ATHENA_MODULES += ath_sound.o[cite: 1]
  IOP_MODULES += libsd.o audsrv.o[cite: 1]

  EE_LIBS += -laudsrv -lvorbisfile -lvorbis -logg[cite: 1]
endif

# MPEG Video support (requires PS2SDK libmpeg)[cite: 1]
MPEG_VIDEO ?= 1[cite: 1]

ifeq ($(MPEG_VIDEO),1)
  EE_CFLAGS += -DATHENA_MPEG_VIDEO[cite: 1]
  APP_CORE += mpeg_player.o[cite: 1]
  ATHENA_MODULES += ath_mpeg.o[cite: 1]
  EE_LIBS += -lmpeg[cite: 1]
endif

ifneq ($(EE_SIO), 0)
  EE_BIN_PREF := $(EE_BIN_PREF)_eesio[cite: 1]
  EE_BIN_PKD := $(EE_BIN_PKD)_eesio[cite: 1]
  EE_CFLAGS += -D__EESIO_PRINTF[cite: 1]
  EE_LIBS += -lsiocookie[cite: 1]
endif

# Static module linking[cite: 1]
ifeq ($(STATIC_NETWORK),1)
  EE_CFLAGS += -DATHENA_NETWORK[cite: 1]
  APP_CORE += network.o request.o[cite: 1]
  ATHENA_MODULES += ath_network.o ath_socket.o ath_request.o ath_websocket.o[cite: 1]
  IOP_MODULES += NETMAN.o SMAP.o ps2ips.o[cite: 1]
  # Native networking backend (lwIP + BearSSL)[cite: 1]
  EE_LIBS += -lnetman -lps2ip[cite: 1]
  APP_CORE += net/ath_http.o net/ath_tls.o net/ath_ws.o[cite: 1]
  # Optional TLS (BearSSL)[cite: 1]
  EE_CFLAGS += -DATHENA_HAS_BEARSSL=1[cite: 1]
  # Prefer vendored BearSSL sources if present; else link against libbearssl[cite: 1]
  ifneq (,$(wildcard $(EE_SRC_DIR)BearSSL/inc/bearssl.h))
    EE_INCS += -I$(EE_SRC_DIR)BearSSL/inc[cite: 1]
    EE_LIBS += -Lee_modules/bearssl/lib -lbearssl[cite: 1]
    EXT_LIBS += ee_modules/bearssl/lib/libbearssl.a[cite: 1]
  else
    EE_LIBS += -lbearssl[cite: 1]
  endif

  DYNAMIC_NETWORK = 0[cite: 1]
endif

ifeq ($(STATIC_KEYBOARD),1)
  EE_CFLAGS += -DATHENA_KEYBOARD[cite: 1]
  ATHENA_MODULES += ath_keyboard.o[cite: 1]
  IOP_MODULES += ps2kbd.o[cite: 1]
  EE_LIBS += -lkbd[cite: 1]

  DYNAMIC_KEYBOARD = 0[cite: 1]
endif

ifeq ($(STATIC_MOUSE),1)
  EE_CFLAGS += -DATHENA_MOUSE[cite: 1]
  ATHENA_MODULES += ath_mouse.o[cite: 1]
  IOP_MODULES += ps2mouse.o[cite: 1]
  EE_LIBS += -lmouse[cite: 1]

  DYNAMIC_MOUSE = 0[cite: 1]
endif

ifeq ($(STATIC_CAMERA),1)
  EE_BIN_PREF := $(EE_BIN_PREF)_cam[cite: 1]
  EE_BIN_PKD := $(EE_BIN_PKD)_cam[cite: 1]
  EE_CFLAGS += -DATHENA_CAMERA[cite: 1]
  ATHENA_MODULES += ath_camera.o[cite: 1]
  IOP_MODULES += ps2cam.o[cite: 1]
  EE_LIBS += -lps2cam[cite: 1]

  DYNAMIC_CAMERA = 0[cite: 1]
endif

# Native compiler (AOT JS to MIPS R5900)[cite: 1]
NATIVE_COMPILER ?= 1[cite: 1]

ifeq ($(NATIVE_COMPILER),1)
  EE_CFLAGS += -DATHENA_NATIVE_COMPILER[cite: 1]
  EE_INCS += -Isrc/native_compiler[cite: 1]
  ATHENA_MODULES += ath_native.o[cite: 1]
  NATIVE_COMPILER_OBJS = native_compiler/native_compiler.o native_compiler/mips_emitter.o native_compiler/type_inference.o native_compiler/native_struct.o native_compiler/int64_runtime.o native_compiler/native_string.o native_compiler/native_array.o[cite: 1]
endif

ATHENA_MODULES := $(ATHENA_MODULES:%=$(JS_API_DIR)%) #prepend the modules folder[cite: 1]
VU1_MPGS := $(VU1_MPGS:%=$(VU1_MPGS_DIR)%) #prepend the microprograms folder[cite: 1]
VU0_MPGS := $(VU0_MPGS:%=$(VU0_MPGS_DIR)%) #prepend the microprograms folder[cite: 1]

EE_OBJS = $(APP_CORE) $(INI_READER) $(JS_CORE) $(ATHENA_MODULES) $(NATIVE_COMPILER_OBJS) $(VU1_MPGS) $(VU0_MPGS) $(IOP_MODULES) $(EMBEDDED_ELFS) $(EMBEDDED_ASSETS) # group them all[cite: 1]
EE_OBJS := $(EE_OBJS:%=$(EE_OBJ_DIR)%) #prepend the object folder[cite: 1]

EE_BIN := $(EE_BIN_DIR)$(EE_BIN_PREF)$(EE_EXT)[cite: 1]
EE_BIN_PKD := $(EE_BIN_DIR)$(EE_BIN_PKD)$(EE_EXT)[cite: 1]


#-------------------------- App Content ---------------------------#[cite: 1]

all: $(DIR_GUARD) $(EXT_LIBS) $(EE_OBJS)[cite: 1]
	$(MAKE) -f Makefile.dl KEYBOARD=$(DYNAMIC_KEYBOARD)[cite: 1]
	$(MAKE) -f Makefile.dl MOUSE=$(DYNAMIC_MOUSE)[cite: 1]

	$(EE_CXX) -T$(EE_LINKFILE) $(EE_OPTFLAGS) -o $(EE_BIN_DIR)tmp.elf $(EE_OBJS) $(EE_LDFLAGS) $(EXTRA_LDFLAGS) -Wno-write-strings $(EE_LIBS) $(EE_SRC_DIR)dummy-exports.c[cite: 1]
	./build-exports.sh[cite: 1]
	$(EE_CXX) -T$(EE_LINKFILE) $(EE_OPTFLAGS) -o $(EE_BIN) $(EE_OBJS) $(EE_LDFLAGS) $(EXTRA_LDFLAGS) -fpermissive -Wno-write-strings $(EE_LIBS) $(EE_SRC_DIR)exports.c[cite: 1]
	rm $(EE_BIN_DIR)tmp.elf[cite: 1]
	@echo "$$HEADER"[cite: 1]
	
	echo "Building $(EE_BIN)..."[cite: 1]
	$(EE_STRIP) $(EE_BIN) [cite: 1]
	
	ps2-packer $(EE_BIN) $(EE_BIN_PKD) > /dev/null[cite: 1]

debug: $(DIR_GUARD) $(EXT_LIBS) $(EE_OBJS) [cite: 1]
	$(MAKE) -f Makefile.dl KEYBOARD=$(DYNAMIC_KEYBOARD)[cite: 1]
	$(MAKE) -f Makefile.dl MOUSE=$(DYNAMIC_MOUSE)[cite: 1]

	$(EE_CXX) -T$(EE_LINKFILE) $(EE_OPTFLAGS) -o $(EE_BIN_DIR)tmp.elf $(EE_OBJS) $(EE_LDFLAGS) $(EXTRA_LDFLAGS) -Wno-write-strings $(EE_LIBS) $(EE_SRC_DIR)dummy-exports.c[cite: 1]
	./build-exports.sh[cite: 1]
	$(EE_CXX) -T$(EE_LINKFILE) $(EE_OPTFLAGS) -o bin/athena_debug.elf $(EE_OBJS) $(EE_LDFLAGS) $(EXTRA_LDFLAGS) -fpermissive -Wno-write-strings $(EE_LIBS) $(EE_SRC_DIR)exports.c[cite: 1]
	rm $(EE_BIN_DIR)tmp.elf[cite: 1]

	echo "Building bin/athena_debug.elf with debug symbols..."[cite: 1]

clean:[cite: 1]
	echo Cleaning executables...[cite: 1]
	rm -f bin/$(EE_BIN) bin/$(EE_BIN_PKD)[cite: 1]
	rm -rf $(EE_OBJ_DIR)[cite: 1]
	rm -rf $(EE_EMBED_DIR)[cite: 1]
	$(MAKE) -C iop_modules/ds34usb clean[cite: 1]
	$(MAKE) -C iop_modules/ds34bt clean[cite: 1]
	$(MAKE) -C ee_modules/loader clean[cite: 1]
	$(MAKE) -C ee_modules/ode clean[cite: 1]
	$(MAKE) -C ee_modules/bearssl clean[cite: 1]

	$(MAKE) -f Makefile.dl KEYBOARD=$(DYNAMIC_KEYBOARD) clean[cite: 1]
	$(MAKE) -f Makefile.dl MOUSE=$(DYNAMIC_MOUSE) clean[cite: 1]

rebuild: clean all[cite: 1]

include $(PS2SDK)/samples/Makefile.pref[cite: 1]
include $(PS2SDK)/samples/Makefile.eeglobal[cite: 1]
include Makefile.embed[cite: 1]

ee_modules/bearssl/lib/libbearssl.a:[cite: 1]
	$(MAKE) -C ee_modules/bearssl[cite: 1]

$(EE_EMBED_DIR):[cite: 1]
	@mkdir -p $@[cite: 1]

$(EE_OBJ_DIR):[cite: 1]
	@mkdir -p $@[cite: 1]

$(EE_OBJ_DIR)%.o: $(EE_SRC_DIR)%.c | $(EE_OBJ_DIR)[cite: 1]
	@echo CC - $<[cite: 1]
	$(DIR_GUARD)[cite: 1]
	$(EE_CC) $(EE_CFLAGS) $(EE_INCS) -c $< -o $@[cite: 1]

$(EE_OBJ_DIR)%.o: $(EE_SRC_DIR)%.s | $(EE_OBJ_DIR)[cite: 1]
	@echo AS - $<[cite: 1]
	$(DIR_GUARD)[cite: 1]
	$(EE_AS) $(EE_ASFLAGS) $(EE_INCS) $< -o $@[cite: 1]

$(EE_OBJ_DIR)%.o: $(EE_SRC_DIR)%.S | $(EE_OBJ_DIR)[cite: 1]
	@echo AS - $<[cite: 1]
	$(DIR_GUARD)[cite: 1]
	$(EE_CC) $(EE_CFLAGS) $(EE_INCS) -c $< -o $@[cite: 1]

$(EE_OBJ_DIR)%.o: $(EE_SRC_DIR)%.vsm | $(EE_OBJ_DIR)[cite: 1]
	@echo DVP - $<[cite: 1]
	$(DIR_GUARD)[cite: 1]
	$(EE_DVP) $< -o $@[cite: 1]

$(EE_SRC_DIR)%.vcl: $(EE_SRC_DIR)%.vclpp | $(EE_SRC_DIR)[cite: 1]
	@echo VCLPP - $<[cite: 1]
	$(DIR_GUARD)[cite: 1]
	$(EE_VCLPP) $< $@.vcl[cite: 1]

$(EE_SRC_DIR)%.vsm: $(EE_SRC_DIR)%.vcl | $(EE_SRC_DIR)[cite: 1]
	@echo VCL - $<[cite: 1]
	$(DIR_GUARD)[cite: 1]
	$(EE_VCL) -Isrc -g -o$@ $<[cite: 1]

$(EE_OBJ_DIR)%.o: $(EE_EMBED_DIR)%.c | $(EE_OBJ_DIR)[cite: 1]
	@echo BIN2C - $<[cite: 1]
	$(DIR_GUARD)[cite: 1]
	$(EE_CC) $(EE_CFLAGS) $(EE_INCS) -c $< -o $@[cite: 1]
