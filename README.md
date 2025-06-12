# sel4_tee
simply add sel4 kernel as TEE OS on an virutal TEE enviroment, currently boot up ok, still have a lot of work to do...

# How to run
1. Please prepare the OPTEE virtual enviroment refer to https://optee.readthedocs.io/en/latest/building/devices/qemu.html#qemu-v8
2. put sel4 & tee_loader under the root directory of your OPTEE-QEMU source file enviroment
3. refer to patches to modify qemu_v8.mk and common.mk in build directory
4. cd build && sudo make -f qemu_v8.mk run
