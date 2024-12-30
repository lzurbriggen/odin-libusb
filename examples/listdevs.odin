package main

import "../"
import "core:c"
import "core:fmt"

print_devs :: proc(devs: [^]^libusb.Device, num: int) {
	dev: ^libusb.Device
	path: [^]c.uint8_t

	for i := 0; i < num; i += 1 {
		dev = devs[i]
		desc: libusb.device_descriptor
		r: c.int = libusb.libusb_get_device_descriptor(dev, &desc)
		if r < 0 {
			fmt.eprintf("failed to get device descriptor")
			return
		}

		fmt.printf(
			"%04x:%04x (bus %d, device %d)",
			desc.idVendor,
			desc.idProduct,
			libusb.libusb_get_bus_number(dev),
			libusb.libusb_get_device_address(dev),
		)

		r = libusb.libusb_get_port_numbers(dev, path, size_of(path))
		if r > 0 {
			fmt.printf(" path: %d", path[0])
			for j := 1; j < int(r); j += 1 {
				fmt.printf(".%d", path[j])
			}
		}
		fmt.printf("\n")
	}
}

main :: proc() {
	devs: [^]^libusb.Device
	r: int
	cnt: c.ssize_t

	r = libusb.libusb_init_context(nil, nil, 0)
	defer libusb.libusb_exit(nil)
	if r < 0 {
		// 	return r;
		fmt.println("err: r < 3")
		return
	}

	cnt = libusb.libusb_get_device_list(nil, &devs)
	defer libusb.libusb_free_device_list(devs, c.int(cnt))

	fmt.println("len", cnt)
	if cnt < 0 {
		return
	}

	print_devs(devs, cnt)
}
