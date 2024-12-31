package libusb

import "core:c"
import "core:c/libc"

// TODO: linux timeval?
// import "core:sys/linux"
import "core:sys/windows"

when ODIN_OS == .Windows {
	timeval :: windows.timeval
} else {
	// timeval :: linux.Time_Val
}


when ODIN_OS == .Windows do foreign import foo "libusb-1.0.lib"
// when ODIN_OS == .Linux do foreign import foo "foo.a"

when ODIN_OS == .Windows {
	foreign import lib "lib/libusb-1.0.lib"
} else {
	foreign import lib "lib/libusb-1.0.a"
}

Class_Code :: enum c.int {
	/** In the context of a \ref libusb_device_descriptor "device descriptor"
	 * this bDeviceClass value indicates that each interface specifies its
	 * own class information and all interfaces operate independently.
	 */
	LIBUSB_CLASS_PER_INTERFACE       = 0x00,
	/** Audio class */
	LIBUSB_CLASS_AUDIO               = 0x01,
	/** Communications class */
	LIBUSB_CLASS_COMM                = 0x02,
	/** Human Interface Device class */
	LIBUSB_CLASS_HID                 = 0x03,
	/** Physical */
	LIBUSB_CLASS_PHYSICAL            = 0x05,
	/** Image class */
	LIBUSB_CLASS_IMAGE               = 0x06,
	LIBUSB_CLASS_PTP                 = 0x06, /* legacy name from libusb-0.1 usb.h */

	/** Printer class */
	LIBUSB_CLASS_PRINTER             = 0x07,
	/** Mass storage class */
	LIBUSB_CLASS_MASS_STORAGE        = 0x08,
	/** Hub class */
	LIBUSB_CLASS_HUB                 = 0x09,
	/** Data class */
	LIBUSB_CLASS_DATA                = 0x0a,
	/** Smart Card */
	LIBUSB_CLASS_SMART_CARD          = 0x0b,
	/** Content Security */
	LIBUSB_CLASS_CONTENT_SECURITY    = 0x0d,
	/** Video */
	LIBUSB_CLASS_VIDEO               = 0x0e,
	/** Personal Healthcare */
	LIBUSB_CLASS_PERSONAL_HEALTHCARE = 0x0f,
	/** Diagnostic Device */
	LIBUSB_CLASS_DIAGNOSTIC_DEVICE   = 0xdc,
	/** Wireless class */
	LIBUSB_CLASS_WIRELESS            = 0xe0,
	/** Miscellaneous class */
	LIBUSB_CLASS_MISCELLANEOUS       = 0xef,
	/** Application class */
	LIBUSB_CLASS_APPLICATION         = 0xfe,
	/** Class is vendor-specific */
	LIBUSB_CLASS_VENDOR_SPEC         = 0xff,
}

Descriptor_Type :: enum c.int {
	/** Device descriptor. See libusb_device_descriptor. */
	LIBUSB_DT_DEVICE                = 0x01,
	/** Configuration descriptor. See libusb_config_descriptor. */
	LIBUSB_DT_CONFIG                = 0x02,
	/** String descriptor */
	LIBUSB_DT_STRING                = 0x03,
	/** Interface descriptor. See libusb_interface_descriptor. */
	LIBUSB_DT_INTERFACE             = 0x04,
	/** Endpoint descriptor. See libusb_endpoint_descriptor. */
	LIBUSB_DT_ENDPOINT              = 0x05,
	/** Interface Association Descriptor.
	* See libusb_interface_association_descriptor */
	LIBUSB_DT_INTERFACE_ASSOCIATION = 0x0b,
	/** BOS descriptor */
	LIBUSB_DT_BOS                   = 0x0f,
	/** Device Capability descriptor */
	LIBUSB_DT_DEVICE_CAPABILITY     = 0x10,
	/** HID descriptor */
	LIBUSB_DT_HID                   = 0x21,
	/** HID report descriptor */
	LIBUSB_DT_REPORT                = 0x22,
	/** Physical descriptor */
	LIBUSB_DT_PHYSICAL              = 0x23,
	/** Hub descriptor */
	LIBUSB_DT_HUB                   = 0x29,
	/** SuperSpeed Hub descriptor */
	LIBUSB_DT_SUPERSPEED_HUB        = 0x2a,
	/** SuperSpeed Endpoint Companion descriptor */
	LIBUSB_DT_SS_ENDPOINT_COMPANION = 0x30,
}

LIBUSB_DT_DEVICE_SIZE :: 18
LIBUSB_DT_CONFIG_SIZE :: 9
LIBUSB_DT_INTERFACE_SIZE :: 9
LIBUSB_DT_ENDPOINT_SIZE :: 7
LIBUSB_DT_ENDPOINT_AUDIO_SIZE :: 9 /* Audio extension */
LIBUSB_DT_HUB_NONVAR_SIZE :: 7
LIBUSB_DT_SS_ENDPOINT_COMPANION_SIZE :: 6
LIBUSB_DT_BOS_SIZE :: 5
LIBUSB_DT_DEVICE_CAPABILITY_SIZE :: 3
LIBUSB_DT_INTERFACE_ASSOCIATION_SIZE :: 8

/* BOS descriptor sizes */
LIBUSB_BT_USB_2_0_EXTENSION_SIZE :: 7
LIBUSB_BT_SS_USB_DEVICE_CAPABILITY_SIZE :: 10
LIBUSB_BT_SSPLUS_USB_DEVICE_CAPABILITY_SIZE :: 12
LIBUSB_BT_CONTAINER_ID_SIZE :: 20
LIBUSB_BT_PLATFORM_DESCRIPTOR_MIN_SIZE :: 20

/* We unwrap the BOS => define its max size */
LIBUSB_DT_BOS_MAX_SIZE ::
	(LIBUSB_DT_BOS_SIZE +
		LIBUSB_BT_USB_2_0_EXTENSION_SIZE +
		LIBUSB_BT_SS_USB_DEVICE_CAPABILITY_SIZE +
		LIBUSB_BT_CONTAINER_ID_SIZE)

LIBUSB_ENDPOINT_ADDRESS_MASK :: 0x0f /* in bEndpointAddress */
LIBUSB_ENDPOINT_DIR_MASK :: 0x80

/** \ingroup libusb_desc
 * Endpoint direction. Values for bit 7 of the
 * \ref libusb_endpoint_descriptor::bEndpointAddress "endpoint address" scheme.
 */
Endpoint_Direction :: enum c.int {
	/** Out: host-to-device */
	LIBUSB_ENDPOINT_OUT = 0x00,
	/** In: device-to-host */
	LIBUSB_ENDPOINT_IN  = 0x80,
}

LIBUSB_TRANSFER_TYPE_MASK :: 0x03 /* in bmAttributes */

/** \ingroup libusb_desc
 * Endpoint transfer type. Values for bits 0:1 of the
 * \ref libusb_endpoint_descriptor::bmAttributes "endpoint attributes" field.
 */
Endpoint_Transfer_Type :: enum c.int {
	/** Control endpoint */
	LIBUSB_ENDPOINT_TRANSFER_TYPE_CONTROL     = 0x0,
	/** Isochronous endpoint */
	LIBUSB_ENDPOINT_TRANSFER_TYPE_ISOCHRONOUS = 0x1,
	/** Bulk endpoint */
	LIBUSB_ENDPOINT_TRANSFER_TYPE_BULK        = 0x2,
	/** Interrupt endpoint */
	LIBUSB_ENDPOINT_TRANSFER_TYPE_INTERRUPT   = 0x3,
}

/** \ingroup libusb_misc
 * Standard requests, as defined in table 9-5 of the USB 3.0 specifications */
Standard_Request :: enum c.int {
	/** Request status of the specific recipient */
	LIBUSB_REQUEST_GET_STATUS        = 0x00,
	/** Clear or disable a specific feature */
	LIBUSB_REQUEST_CLEAR_FEATURE     = 0x01,

	/* 0x02 is reserved */

	/** Set or enable a specific feature */
	LIBUSB_REQUEST_SET_FEATURE       = 0x03,

	/* 0x04 is reserved */

	/** Set device address for all future accesses */
	LIBUSB_REQUEST_SET_ADDRESS       = 0x05,
	/** Get the specified descriptor */
	LIBUSB_REQUEST_GET_DESCRIPTOR    = 0x06,
	/** Used to update existing descriptors or add new descriptors */
	LIBUSB_REQUEST_SET_DESCRIPTOR    = 0x07,
	/** Get the current device configuration value */
	LIBUSB_REQUEST_GET_CONFIGURATION = 0x08,
	/** Set device configuration */
	LIBUSB_REQUEST_SET_CONFIGURATION = 0x09,
	/** Return the selected alternate setting for the specified interface */
	LIBUSB_REQUEST_GET_INTERFACE     = 0x0a,
	/** Select an alternate interface for the specified interface */
	LIBUSB_REQUEST_SET_INTERFACE     = 0x0b,
	/** Set then report an endpoint's synchronization frame */
	LIBUSB_REQUEST_SYNCH_FRAME       = 0x0c,
	/** Sets both the U1 and U2 Exit Latency */
	LIBUSB_REQUEST_SET_SEL           = 0x30,
	/** Delay from the time a host transmits a packet to the time it is
	  * received by the device. */
	LIBUSB_SET_ISOCH_DELAY           = 0x31,
}

/** \ingroup libusb_misc
 * Request type bits of the
 * \ref libusb_control_setup::bmRequestType "bmRequestType" field in control
 * transfers. */
Request_Type :: enum c.int {
	/** Standard */
	LIBUSB_REQUEST_TYPE_STANDARD = (0x00 << 5),
	/** Class */
	LIBUSB_REQUEST_TYPE_CLASS    = (0x01 << 5),
	/** Vendor */
	LIBUSB_REQUEST_TYPE_VENDOR   = (0x02 << 5),
	/** Reserved */
	LIBUSB_REQUEST_TYPE_RESERVED = (0x03 << 5),
}

/** \ingroup libusb_misc
 * Recipient bits of the
 * \ref libusb_control_setup::bmRequestType "bmRequestType" field in control
 * transfers. Values 4 through 31 are reserved. */
Request_Recipient :: enum c.int {
	/** Device */
	LIBUSB_RECIPIENT_DEVICE    = 0x00,
	/** Interface */
	LIBUSB_RECIPIENT_INTERFACE = 0x01,
	/** Endpoint */
	LIBUSB_RECIPIENT_ENDPOINT  = 0x02,
	/** Other */
	LIBUSB_RECIPIENT_OTHER     = 0x03,
}

LIBUSB_ISO_SYNC_TYPE_MASK :: 0x0c

/** \ingroup libusb_desc
 * Synchronization type for isochronous endpoints. Values for bits 2:3 of the
 * \ref libusb_endpoint_descriptor::bmAttributes "bmAttributes" field in
 * libusb_endpoint_descriptor.
 */
Iso_Sync_Type :: enum c.int {
	/** No synchronization */
	LIBUSB_ISO_SYNC_TYPE_NONE     = 0x0,
	/** Asynchronous */
	LIBUSB_ISO_SYNC_TYPE_ASYNC    = 0x1,
	/** Adaptive */
	LIBUSB_ISO_SYNC_TYPE_ADAPTIVE = 0x2,
	/** Synchronous */
	LIBUSB_ISO_SYNC_TYPE_SYNC     = 0x3,
}

LIBUSB_ISO_USAGE_TYPE_MASK :: 0x30

/** \ingroup libusb_desc
 * Usage type for isochronous endpoints. Values for bits 4:5 of the
 * \ref libusb_endpoint_descriptor::bmAttributes "bmAttributes" field in
 * libusb_endpoint_descriptor.
 */
Iso_Usage_Type :: enum c.int {
	/** Data endpoint */
	LIBUSB_ISO_USAGE_TYPE_DATA     = 0x0,
	/** Feedback endpoint */
	LIBUSB_ISO_USAGE_TYPE_FEEDBACK = 0x1,
	/** Implicit feedback Data endpoint */
	LIBUSB_ISO_USAGE_TYPE_IMPLICIT = 0x2,
}

/** \ingroup libusb_desc
 * Supported speeds (wSpeedSupported) bitfield. Indicates what
 * speeds the device supports.
 */
Supported_Speed :: enum c.int {
	/** Low speed operation supported (1.5MBit/s). */
	LIBUSB_LOW_SPEED_OPERATION   = (1 << 0),
	/** Full speed operation supported (12MBit/s). */
	LIBUSB_FULL_SPEED_OPERATION  = (1 << 1),
	/** High speed operation supported (480MBit/s). */
	LIBUSB_HIGH_SPEED_OPERATION  = (1 << 2),
	/** Superspeed operation supported (5000MBit/s). */
	LIBUSB_SUPER_SPEED_OPERATION = (1 << 3),
}

/** \ingroup libusb_desc
 * Masks for the bits of the
 * \ref libusb_usb_2_0_extension_descriptor::bmAttributes "bmAttributes" field
 * of the USB 2.0 Extension descriptor.
 */
USB20_Extension_Attributes :: enum c.int {
	/** Supports Link Power Management (LPM) */
	LIBUSB_BM_LPM_SUPPORT = (1 << 1),
}

/** \ingroup libusb_desc
 * Masks for the bits of the
 * \ref libusb_ss_usb_device_capability_descriptor::bmAttributes "bmAttributes" field
 * field of the SuperSpeed USB Device Capability descriptor.
 */
SS_USB_Device_Capability_Attributes :: enum c.int {
	/** Supports Latency Tolerance Messages (LTM) */
	LIBUSB_BM_LTM_SUPPORT = (1 << 1),
}

/** \ingroup libusb_desc
 * USB capability types
 */
Bos_Type :: enum c.int {
	/** Wireless USB device capability */
	LIBUSB_BT_WIRELESS_USB_DEVICE_CAPABILITY = 0x01,
	/** USB 2.0 extensions */
	LIBUSB_BT_USB_2_0_EXTENSION              = 0x02,
	/** SuperSpeed USB device capability */
	LIBUSB_BT_SS_USB_DEVICE_CAPABILITY       = 0x03,
	/** Container ID type */
	LIBUSB_BT_CONTAINER_ID                   = 0x04,
	/** Platform descriptor */
	LIBUSB_BT_PLATFORM_DESCRIPTOR            = 0x05,
	/** SuperSpeedPlus device capability */
	LIBUSB_BT_SUPERSPEED_PLUS_CAPABILITY     = 0x0A,
}

/** \ingroup libusb_desc
 * A structure representing the standard USB device descriptor. This
 * descriptor is documented in section 9.6.1 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 */
device_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:            c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE LIBUSB_DT_DEVICE in this
	 * context. */
	bDescriptorType:    c.uint8_t,
	/** USB specification release number in binary-coded decimal. A value of
	 * 0x0200 indicates USB 2.0, 0x0110 indicates USB 1.1, etc. */
	bcdUSB:             c.uint16_t,
	/** USB-IF class code for the device. See \ref libusb_class_code. */
	bDeviceClass:       c.uint8_t,
	/** USB-IF subclass code for the device, qualified by the bDeviceClass
	 * value */
	bDeviceSubClass:    c.uint8_t,
	/** USB-IF protocol code for the device, qualified by the bDeviceClass and
	 * bDeviceSubClass values */
	bDeviceProtocol:    c.uint8_t,
	/** Maximum packet size for endpoint 0 */
	bMaxPacketSize0:    c.uint8_t,
	/** USB-IF vendor ID */
	idVendor:           c.uint16_t,
	/** USB-IF product ID */
	idProduct:          c.uint16_t,
	/** Device release number in binary-coded decimal */
	bcdDevice:          c.uint16_t,
	/** Index of string descriptor describing manufacturer */
	iManufacturer:      c.uint8_t,
	/** Index of string descriptor describing product */
	iProduct:           c.uint8_t,
	/** Index of string descriptor containing device serial number */
	iSerialNumber:      c.uint8_t,
	/** Number of possible configurations */
	bNumConfigurations: c.uint8_t,
}

/** \ingroup libusb_desc
 * A structure representing the standard USB endpoint descriptor. This
 * descriptor is documented in section 9.6.6 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 */
Endpoint_Descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:          c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_ENDPOINT LIBUSB_DT_ENDPOINT in
	 * this context. */
	bDescriptorType:  c.uint8_t,
	/** The address of the endpoint described by this descriptor. Bits 0:3 are
	 * the endpoint number. Bits 4:6 are reserved. Bit 7 indicates direction,
	 * see \ref libusb_endpoint_direction. */
	bEndpointAddress: c.uint8_t,
	/** Attributes which apply to the endpoint when it is configured using
	 * the bConfigurationValue. Bits 0:1 determine the transfer type and
	 * correspond to \ref libusb_endpoint_transfer_type. Bits 2:3 are only used
	 * for isochronous endpoints and correspond to \ref libusb_iso_sync_type.
	 * Bits 4:5 are also only used for isochronous endpoints and correspond to
	 * \ref libusb_iso_usage_type. Bits 6:7 are reserved. */
	bmAttributes:     c.uint8_t,
	/** Maximum packet size this endpoint is capable of sending/receiving. */
	wMaxPacketSize:   c.uint16_t,
	/** Interval for polling endpoint for data transfers. */
	bInterval:        c.uint8_t,
	/** For audio devices only: the rate at which synchronization feedback
	 * is provided. */
	bRefresh:         c.uint8_t,
	/** For audio devices only: the address if the synch endpoint */
	bSynchAddress:    c.uint8_t,
	/** Extra descriptors. If libusb encounters unknown endpoint descriptors,
	 * it will store them here, should you wish to parse them. */
	extra:            ^u8,
	/** Length of the extra descriptors, in bytes. Must be non-negative. */
	extra_length:     int,
}

/** \ingroup libusb_desc
 * A structure representing the standard USB interface association descriptor.
 * This descriptor is documented in section 9.6.4 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 */
interface_association_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:           c.uint8_t,
	/** Descriptor type. Will have value
	* \ref libusb_descriptor_type::LIBUSB_DT_INTERFACE_ASSOCIATION
	* LIBUSB_DT_INTERFACE_ASSOCIATION in this context. */
	bDescriptorType:   c.uint8_t,
	/** Interface number of the first interface that is associated
	* with this function */
	bFirstInterface:   c.uint8_t,
	/** Number of contiguous interfaces that are associated with
	* this function */
	bInterfaceCount:   c.uint8_t,
	/** USB-IF class code for this function.
	* A value of zero is not allowed in this descriptor.
	* If this field is 0xff, the function class is vendor-specific.
	* All other values are reserved for assignment by the USB-IF.
	*/
	bFunctionClass:    c.uint8_t,
	/** USB-IF subclass code for this function.
	* If this field is not set to 0xff, all values are reserved
	* for assignment by the USB-IF
	*/
	bFunctionSubClass: c.uint8_t,
	/** USB-IF protocol code for this function.
	* These codes are qualified by the values of the bFunctionClass
	* and bFunctionSubClass fields.
	*/
	bFunctionProtocol: c.uint8_t,
	/** Index of string descriptor describing this function */
	iFunction:         c.uint8_t,
}

/** \ingroup libusb_desc
 * Structure containing an array of 0 or more interface association
 * descriptors
 */
interface_association_descriptor_array :: struct {
	/** Array of interface association descriptors. The size of this array
	 * is determined by the length field.
	 */
	iad:    interface_association_descriptor, //const interface_association_descriptor::struct;

	/** Number of interface association descriptors contained. Read-only. */
	length: int,
}

/** \ingroup libusb_desc
 * A structure representing the standard USB interface descriptor. This
 * descriptor is documented in section 9.6.5 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 */
Interface_Descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:            c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_INTERFACE LIBUSB_DT_INTERFACE
	 * in this context. */
	bDescriptorType:    c.uint8_t,
	/** Number of this interface */
	bInterfaceNumber:   c.uint8_t,
	/** Value used to select this alternate setting for this interface */
	bAlternateSetting:  c.uint8_t,
	/** Number of endpoints used by this interface (excluding the control
	 * endpoint). */
	bNumEndpoints:      c.uint8_t,
	/** USB-IF class code for this interface. See \ref libusb_class_code. */
	bInterfaceClass:    c.uint8_t,
	/** USB-IF subclass code for this interface, qualified by the
	 * bInterfaceClass value */
	bInterfaceSubClass: c.uint8_t,
	/** USB-IF protocol code for this interface, qualified by the
	 * bInterfaceClass and bInterfaceSubClass values */
	bInterfaceProtocol: c.uint8_t,
	/** Index of string descriptor describing this interface */
	iInterface:         c.uint8_t,
	/** Array of endpoint descriptors. This length of this array is determined
	 * by the bNumEndpoints field. */
	endpoint:           Endpoint_Descriptor, //const endpoint_descriptor::struct,
	/** Extra descriptors. If libusb encounters unknown interface descriptors,
	 * it will store them here, should you wish to parse them. */
	extra:              ^u8,
	/** Length of the extra descriptors, in bytes. Must be non-negative. */
	extra_length:       int,
}

/** \ingroup libusb_desc
 * A collection of alternate settings for a particular USB interface.
 */
interface :: struct {
	/** Array of interface descriptors. The length of this array is determined
	 * by the num_altsetting field. */
	altsetting:     Interface_Descriptor,
	/** The number of alternate settings that belong to this interface.
	 * Must be non-negative. */
	num_altsetting: int,
}

/** \ingroup libusb_desc
 * A structure representing the standard USB configuration descriptor. This
 * descriptor is documented in section 9.6.3 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 */
config_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:             c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_CONFIG LIBUSB_DT_CONFIG
	 * in this context. */
	bDescriptorType:     c.uint8_t,
	/** Total length of data returned for this configuration */
	wTotalLength:        c.uint16_t,
	/** Number of interfaces supported by this configuration */
	bNumInterfaces:      c.uint8_t,
	/** Identifier value for this configuration */
	bConfigurationValue: c.uint8_t,
	/** Index of string descriptor describing this configuration */
	iConfiguration:      c.uint8_t,
	/** Configuration characteristics */
	bmAttributes:        c.uint8_t,
	/** Maximum power consumption of the USB device from this bus in this
	 * configuration when the device is fully operation. Expressed in units
	 * of 2 mA when the device is operating in high-speed mode and in units
	 * of 8 mA when the device is operating in super-speed mode. */
	MaxPower:            c.uint8_t,
	/** Array of interfaces supported by this configuration. The length of
	 * this array is determined by the bNumInterfaces field. */
	interface:           ^interface,
	/** Extra descriptors. If libusb encounters unknown configuration
	 * descriptors, it will store them here, should you wish to parse them. */
	extra:               ^byte,
	/** Length of the extra descriptors, in bytes. Must be non-negative. */
	extra_length:        int,
}

/** \ingroup libusb_desc
 * A structure representing the superspeed endpoint companion
 * descriptor. This descriptor is documented in section 9.6.7 of
 * the USB 3.0 specification. All multiple-byte fields are represented in
 * host-endian format.
 */
ss_endpoint_companion_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:           c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_SS_ENDPOINT_COMPANION in
	 * this context. */
	bDescriptorType:   c.uint8_t,
	/** The maximum number of packets the endpoint can send or
	 *  receive as part of a burst. */
	bMaxBurst:         c.uint8_t,
	/** In bulk EP: bits 4:0 represents the maximum number of
	 *  streams the EP supports. In isochronous EP: bits 1:0
	 *  represents the Mult - a zero based value that determines
	 *  the maximum number of packets within a service interval  */
	bmAttributes:      c.uint8_t,
	/** The total number of bytes this EP will transfer every
	 *  service interval. Valid only for periodic EPs. */
	wBytesPerInterval: c.uint16_t,
}

/** \ingroup libusb_desc
 * A generic representation of a BOS Device Capability descriptor. It is
 * advised to check bDevCapabilityType and call the matching
 * libusb_get_*_descriptor function to get a structure fully matching the type.
 */
bos_dev_capability_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:            c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE_CAPABILITY
	 * LIBUSB_DT_DEVICE_CAPABILITY in this context. */
	bDescriptorType:    c.uint8_t,
	/** Device Capability type */
	bDevCapabilityType: c.uint8_t,
	/** Device Capability data (bLength - 3 bytes) */
	// TODO
	//   dev_capability_data[LIBUSB_FLEXIBLE_ARRAY]:c.uint8_t,
}

/** \ingroup libusb_desc
 * A structure representing the Binary Device Object Store (BOS) descriptor.
 * This descriptor is documented in section 9.6.2 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 */
bos_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:         c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_BOS LIBUSB_DT_BOS
	 * in this context. */
	bDescriptorType: c.uint8_t,
	/** Length of this descriptor and all of its sub descriptors */
	wTotalLength:    c.uint16_t,
	/** The number of separate device capability descriptors in
	 * the BOS */
	bNumDeviceCaps:  c.uint8_t,
	/** bNumDeviceCap Device Capability Descriptors */
	// TODO
	// dev_capability[LIBUSB_FLEXIBLE_ARRAY]: ^Bos_Dev_Capability_Descriptor,
}

/** \ingroup libusb_desc
 * A structure representing the USB 2.0 Extension descriptor
 * This descriptor is documented in section 9.6.2.1 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 */
usb_2_0_extension_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:            c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE_CAPABILITY
	 * LIBUSB_DT_DEVICE_CAPABILITY in this context. */
	bDescriptorType:    c.uint8_t,
	/** Capability type. Will have value
	 * \ref libusb_bos_type::LIBUSB_BT_USB_2_0_EXTENSION
	 * LIBUSB_BT_USB_2_0_EXTENSION in this context. */
	bDevCapabilityType: c.uint8_t,
	/** Bitmap encoding of supported device level features.
	 * A value of one in a bit location indicates a feature is
	 * supported; a value of zero indicates it is not supported.
	 * See \ref libusb_usb_2_0_extension_attributes. */
	bmAttributes:       c.uint32_t,
}

/** \ingroup libusb_desc
 * A structure representing the SuperSpeed USB Device Capability descriptor
 * This descriptor is documented in section 9.6.2.2 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 */
ss_usb_device_capability_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:               c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE_CAPABILITY
	 * LIBUSB_DT_DEVICE_CAPABILITY in this context. */
	bDescriptorType:       c.uint8_t,
	/** Capability type. Will have value
	 * \ref libusb_bos_type::LIBUSB_BT_SS_USB_DEVICE_CAPABILITY
	 * LIBUSB_BT_SS_USB_DEVICE_CAPABILITY in this context. */
	bDevCapabilityType:    c.uint8_t,
	/** Bitmap encoding of supported device level features.
	 * A value of one in a bit location indicates a feature is
	 * supported; a value of zero indicates it is not supported.
	 * See \ref libusb_ss_usb_device_capability_attributes. */
	bmAttributes:          c.uint8_t,
	/** Bitmap encoding of the speed supported by this device when
	 * operating in SuperSpeed mode. See \ref libusb_supported_speed. */
	wSpeedSupported:       c.uint16_t,
	/** The lowest speed at which all the functionality supported
	 * by the device is available to the user. For example if the
	 * device supports all its functionality when connected at
	 * full speed and above then it sets this value to 1. */
	bFunctionalitySupport: c.uint8_t,
	/** U1 Device Exit Latency. */
	bU1DevExitLat:         c.uint8_t,
	/** U2 Device Exit Latency. */
	bU2DevExitLat:         c.uint16_t,
}

/** \ingroup libusb_desc
 *  enum used in \ref libusb_ssplus_sublink_attribute
 */
superspeedplus_sublink_attribute_sublink_type :: enum c.int {
	LIBUSB_SSPLUS_ATTR_TYPE_SYM  = 0,
	LIBUSB_SSPLUS_ATTR_TYPE_ASYM = 1,
}

/** \ingroup libusb_desc
 *  enum used in \ref libusb_ssplus_sublink_attribute
 */
superspeedplus_sublink_attribute_sublink_direction :: enum c.int {
	LIBUSB_SSPLUS_ATTR_DIR_RX = 0,
	LIBUSB_SSPLUS_ATTR_DIR_TX = 1,
}

/** \ingroup libusb_desc
 *  enum used in \ref libusb_ssplus_sublink_attribute
 *   Bit   = Bits per second
 *   Kb = Kbps
 *   Mb = Mbps
 *   Gb = Gbps
 */
superspeedplus_sublink_attribute_exponent :: enum c.int {
	LIBUSB_SSPLUS_ATTR_EXP_BPS = 0,
	LIBUSB_SSPLUS_ATTR_EXP_KBS = 1,
	LIBUSB_SSPLUS_ATTR_EXP_MBS = 2,
	LIBUSB_SSPLUS_ATTR_EXP_GBS = 3,
}

/** \ingroup libusb_desc
 *  enum used in \ref libusb_ssplus_sublink_attribute
 */
superspeedplus_sublink_attribute_link_protocol :: enum c.int {
	LIBUSB_SSPLUS_ATTR_PROT_SS     = 0,
	LIBUSB_SSPLUS_ATTR_PROT_SSPLUS = 1,
}

/** \ingroup libusb_desc
 * Expose \ref libusb_ssplus_usb_device_capability_descriptor.sublinkSpeedAttributes
 */
ssplus_sublink_attribute :: struct {
	/** Sublink Speed Attribute ID (SSID).
	 This field is an ID that uniquely identifies the speed of this sublink */
	ssid:      c.uint8_t,
	/** This field defines the
	 base 10 exponent times 3, that shall be applied to the
     mantissa. */
	exponent:  superspeedplus_sublink_attribute_exponent,
	/** This field identifies whether the
	 Sublink Speed Attribute defines a symmetric or
     asymmetric bit rate.*/
	type:      superspeedplus_sublink_attribute_sublink_type,
	/** This field  indicates if this
	 Sublink Speed Attribute defines the receive or
     transmit bit rate. */
	direction: superspeedplus_sublink_attribute_sublink_direction,
	/** This field identifies the protocol
	 supported by the link. */
	protocol:  superspeedplus_sublink_attribute_link_protocol,
	/** This field defines the mantissa that shall be applied to the exponent when
     calculating the maximum bit rate. */
	mantissa:  c.uint16_t,
}

/** \ingroup libusb_desc
 * A structure representing the SuperSpeedPlus descriptor
 * This descriptor is documented in section 9.6.2.5 of the USB 3.1 specification.
 */
ssplus_usb_device_capability_descriptor :: struct {
	/** Sublink Speed Attribute Count */
	numSublinkSpeedAttributes: c.uint8_t,
	/** Sublink Speed ID Count */
	numSublinkSpeedIDs:        c.uint8_t,
	/** Unique ID to indicates the minimum lane speed */
	ssid:                      c.uint8_t,
	/** This field indicates the minimum receive lane count.*/
	minRxLaneCount:            c.uint8_t,
	/** This field indicates the minimum transmit lane count*/
	minTxLaneCount:            c.uint8_t,
	/** Array size is \ref libusb_ssplus_usb_device_capability_descriptor.numSublinkSpeedAttributes */
	sublinkSpeedAttributes:    []ssplus_sublink_attribute, // TODO: array?
}

/** \ingroup libusb_desc
 * A structure representing the Container ID descriptor.
 * This descriptor is documented in section 9.6.2.3 of the USB 3.0 specification.
 * All multiple-byte fields, except UUIDs, are represented in host-endian format.
 */
container_id_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:            c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE_CAPABILITY
	 * LIBUSB_DT_DEVICE_CAPABILITY in this context. */
	bDescriptorType:    c.uint8_t,
	/** Capability type. Will have value
	 * \ref libusb_bos_type::LIBUSB_BT_CONTAINER_ID
	 * LIBUSB_BT_CONTAINER_ID in this context. */
	bDevCapabilityType: c.uint8_t,
	/** Reserved field */
	bReserved:          c.uint8_t,
	/** 128 bit UUID */
	// TODO
	//  ContainerID[16]: c.uint8_t ,
}

/** \ingroup libusb_desc
 * A structure representing a Platform descriptor.
 * This descriptor is documented in section 9.6.2.4 of the USB 3.2 specification.
 */
platform_descriptor :: struct {
	/** Size of this descriptor (in bytes) */
	bLength:                c.uint8_t,
	/** Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE_CAPABILITY
	 * LIBUSB_DT_DEVICE_CAPABILITY in this context. */
	bDescriptorType:        c.uint8_t,
	/** Capability type. Will have value
	 * \ref libusb_bos_type::LIBUSB_BT_PLATFORM_DESCRIPTOR
	 * LIBUSB_BT_CONTAINER_ID in this context. */
	bDevCapabilityType:     c.uint8_t,
	/** Reserved field */
	bReserved:              c.uint8_t,
	/** 128 bit UUID */
	PlatformCapabilityUUID: [16]c.uint8_t,
	/** Capability data (bLength - 20) */
	// TODO
	//  CapabilityData[LIBUSB_FLEXIBLE_ARRAY]: c.uint8_t ,
}

/** \ingroup libusb_asyncio
 * Setup packet for control transfers. */
control_setup :: struct #packed {
	/** Request type. Bits 0:4 determine recipient, see
      * \ref libusb_request_recipient. Bits 5:6 determine type, see
      * \ref libusb_request_type. Bit 7 determines data transfer direction, see
      * \ref libusb_endpoint_direction.
      */
	bmRequestType: c.uint8_t,
	/** Request. If the type bits of bmRequestType are equal to
      * \ref libusb_request_type::LIBUSB_REQUEST_TYPE_STANDARD
      * "LIBUSB_REQUEST_TYPE_STANDARD" then this field refers to
      * \ref libusb_standard_request. For other cases, use of this field is
      * application-specific. */
	bRequest:      c.uint8_t,
	/** Value. Varies according to request */
	wValue:        c.uint16_t,
	/** Index. Varies according to request, typically used to pass an index
      * or offset */
	wIndex:        c.uint16_t,
	/** Number of bytes to transfer */
	wLength:       c.uint16_t,
}

LIBUSB_CONTROL_SETUP_SIZE :: size_of(control_setup)

/* libusb */

Libusb_Context :: struct {}
Device :: struct {}
Device_Handle :: struct {}

/** \ingroup libusb_lib
  * Structure providing the version of the libusb runtime
  */
Version :: struct {
	/** Library major version. */
	major:    c.uint16_t,
	/** Library minor version. */
	minor:    c.uint16_t,
	/** Library micro version. */
	micro:    c.uint16_t,
	/** Library nano version. */
	nano:     c.uint16_t,
	/** Library release candidate suffix string, e.g. "-rc4". */
	rc:       ^c.char,
	/** For ABI compatibility only. */
	describe: ^c.char,
}

/** \ingroup libusb_dev
 * Speed codes. Indicates the speed at which the device is operating.
 */
speed :: enum c.int {
	/** The OS doesn't report or know the device speed. */
	LIBUSB_SPEED_UNKNOWN       = 0,
	/** The device is operating at low speed (1.5MBit/s). */
	LIBUSB_SPEED_LOW           = 1,
	/** The device is operating at full speed (12MBit/s). */
	LIBUSB_SPEED_FULL          = 2,
	/** The device is operating at high speed (480MBit/s). */
	LIBUSB_SPEED_HIGH          = 3,
	/** The device is operating at super speed (5000MBit/s). */
	LIBUSB_SPEED_SUPER         = 4,
	/** The device is operating at super speed plus (10000MBit/s). */
	LIBUSB_SPEED_SUPER_PLUS    = 5,
	/** The device is operating at super speed plus x2 (20000MBit/s). */
	LIBUSB_SPEED_SUPER_PLUS_X2 = 6,
}

/** \ingroup libusb_misc
 * Error codes. Most libusb functions return 0 on success or one of these
 * codes on failure.
 * You can call libusb_error_name() to retrieve a string representation of an
 * error code or libusb_strerror() to get an end-user suitable description of
 * an error code.
 */
error :: enum c.int {
	/** Success (no error) */
	LIBUSB_SUCCESS             = 0,
	/** Input/output error */
	LIBUSB_ERROR_IO            = -1,
	/** Invalid parameter */
	LIBUSB_ERROR_INVALID_PARAM = -2,
	/** Access denied (insufficient permissions) */
	LIBUSB_ERROR_ACCESS        = -3,
	/** No such device (it may have been disconnected) */
	LIBUSB_ERROR_NO_DEVICE     = -4,
	/** Entity not found */
	LIBUSB_ERROR_NOT_FOUND     = -5,
	/** Resource busy */
	LIBUSB_ERROR_BUSY          = -6,
	/** Operation timed out */
	LIBUSB_ERROR_TIMEOUT       = -7,
	/** Overflow */
	LIBUSB_ERROR_OVERFLOW      = -8,
	/** Pipe error */
	LIBUSB_ERROR_PIPE          = -9,
	/** System call interrupted (perhaps due to signal) */
	LIBUSB_ERROR_INTERRUPTED   = -10,
	/** Insufficient memory */
	LIBUSB_ERROR_NO_MEM        = -11,
	/** Operation not supported or unimplemented on this platform */
	LIBUSB_ERROR_NOT_SUPPORTED = -12,

	/* NB: Remember to update LIBUSB_ERROR_COUNT below as well as the
	   message strings in strerror.c when adding new error codes here. */

	/** Other error */
	LIBUSB_ERROR_OTHER         = -99,
}

/* Total number of error codes in error */
LIBUSB_ERROR_COUNT :: 14

/** \ingroup libusb_asyncio
 * Transfer type */
transfer_type :: enum c.int {
	/** Control transfer */
	LIBUSB_TRANSFER_TYPE_CONTROL     = 0, // 0U,
	/** Isochronous transfer */
	LIBUSB_TRANSFER_TYPE_ISOCHRONOUS = 11, //1U,
	/** Bulk transfer */
	LIBUSB_TRANSFER_TYPE_BULK        = 2, // 2U,
	/** Interrupt transfer */
	LIBUSB_TRANSFER_TYPE_INTERRUPT   = 3, // 3U,
	/** Bulk stream transfer */
	LIBUSB_TRANSFER_TYPE_BULK_STREAM = 4, // 4U
}

/** \ingroup libusb_asyncio
 * Transfer status codes */
Transfer_Status :: enum c.int {
	/** Transfer completed without error. Note that this does not indicate
	 * that the entire amount of requested data was transferred. */
	LIBUSB_TRANSFER_COMPLETED,
	/** Transfer failed */
	LIBUSB_TRANSFER_ERROR,
	/** Transfer timed out */
	LIBUSB_TRANSFER_TIMED_OUT,
	/** Transfer was cancelled */
	LIBUSB_TRANSFER_CANCELLED,
	/** For bulk/interrupt endpoints: halt condition detected (endpoint
	 * stalled). For control endpoints: control request not supported. */
	LIBUSB_TRANSFER_STALL,
	/** Device was disconnected */
	LIBUSB_TRANSFER_NO_DEVICE,
	/** Device sent more data than requested */
	LIBUSB_TRANSFER_OVERFLOW,

	/* NB! Remember to update libusb_error_name()
	   when adding new status codes here. */
}

/** \ingroup libusb_asyncio
 * libusb_transfer.flags values */
transfer_flags :: enum c.uint {
	/** Report short frames as errors */
	LIBUSB_TRANSFER_SHORT_NOT_OK    = 1 << 0, //(1U << 0),
	/** Automatically free() transfer buffer during libusb_free_transfer().
	 * Note that buffers allocated with libusb_dev_mem_alloc() should not
	 * be attempted freed in this way, since free() is not an appropriate
	 * way to release such memory. */
	LIBUSB_TRANSFER_FREE_BUFFER     = 1 << 1, //(1U << 1),
	/** Automatically call libusb_free_transfer() after callback returns.
	 * If this flag is set, it is illegal to call libusb_free_transfer()
	 * from your transfer callback, as this will result in a double-free
	 * when this flag is acted upon. */
	LIBUSB_TRANSFER_FREE_TRANSFER   = 1 << 2, //(1U << 2),
	/** Terminate transfers that are a multiple of the endpoint's
	 * wMaxPacketSize with an extra zero length packet. This is useful
	 * when a device protocol mandates that each logical request is
	 * terminated by an incomplete packet (i.e. the logical requests are
	 * not separated by other means).
	 *
	 * This flag only affects host-to-device transfers to bulk and interrupt
	 * endpoints. In other situations, it is ignored.
	 *
	 * This flag only affects transfers with a length that is a multiple of
	 * the endpoint's wMaxPacketSize. On transfers of other lengths, this
	 * flag has no effect. Therefore, if you are working with a device that
	 * needs a ZLP whenever the end of the logical request falls on a packet
	 * boundary, then it is sensible to set this flag on <em>every</em>
	 * transfer (you do not have to worry about only setting it on transfers
	 * that end on the boundary).
	 *
	 * This flag is currently only supported on Linux.
	 * On other systems, libusb_submit_transfer() will return
	 * \ref LIBUSB_ERROR_NOT_SUPPORTED for every transfer where this
	 * flag is set.
	 *
	 * Available since libusb-1.0.9.
	 */
	LIBUSB_TRANSFER_ADD_ZERO_PACKET = 1 << 3, //(1U << 3)
}

/** \ingroup libusb_asyncio
 * Isochronous packet descriptor. */
libusb_iso_packet_descriptor :: struct {
	/** Length of data to request in this packet */
	length:        c.uint,
	/** Amount of data that was actually transferred */
	actual_length: c.uint,
	/** Status code for this packet */
	status:        Transfer_Status,
}

Transfer :: struct {}

/** \ingroup libusb_asyncio
 * Asynchronous transfer callback function type. When submitting asynchronous
 * transfers, you pass a pointer to a callback function of this type via the
 * \ref libusb_transfer::callback "callback" member of the libusb_transfer
 * structure. libusb will call this function later, when the transfer has
 * completed or failed. See \ref libusb_asyncio for more information.
 * \param transfer The libusb_transfer struct the callback function is being
 * notified about.
 */
libusb_transfer_cb_fn :: ^Transfer

/** \ingroup libusb_asyncio
 * The generic USB transfer structure. The user populates this structure and
 * then submits it in order to request a transfer. After the transfer has
 * completed, the library populates the transfer with the results and passes
 * it back to the user.
 */
libusb_transfer :: struct {
	/** Handle of the device that this transfer will be submitted to */
	dev_handle:      ^Device_Handle,
	/** A bitwise OR combination of \ref libusb_transfer_flags. */
	flags:           c.uint8_t,
	/** Address of the endpoint where this transfer will be sent. */
	endpoint:        c.uchar,
	/** Type of the transfer from \ref libusb_transfer_type */
	type:            c.uchar,
	/** Timeout for this transfer in milliseconds. A value of 0 indicates no
	 * timeout. */
	timeout:         c.int,
	/** The status of the transfer. Read-only, and only for use within
	 * transfer callback function.
	 *
	 * If this is an isochronous transfer, this field may read COMPLETED even
	 * if there were errors in the frames. Use the
	 * \ref libusb_iso_packet_descriptor::status "status" field in each packet
	 * to determine if errors occurred. */
	status:          Transfer_Status,
	/** Length of the data buffer. Must be non-negative. */
	length:          c.int,
	/** Actual length of data that was transferred. Read-only, and only for
	 * use within transfer callback function. Not valid for isochronous
	 * endpoint transfers. */
	actual_length:   c.int,
	/** Callback function. This will be invoked when the transfer completes,
	 * fails, or is cancelled. */
	callback:        libusb_transfer_cb_fn,
	/** User context data. Useful for associating specific data to a transfer
	 * that can be accessed from within the callback function.
	 *
	 * This field may be set manually or is taken as the `user_data` parameter
	 * of the following functions:
	 * - libusb_fill_bulk_transfer()
	 * - libusb_fill_bulk_stream_transfer()
	 * - libusb_fill_control_transfer()
	 * - libusb_fill_interrupt_transfer()
	 * - libusb_fill_iso_transfer() */
	user_data:       rawptr,
	/** Data buffer */
	buffer:          ^c.uchar,
	/** Number of isochronous packets. Only used for I/O with isochronous
	 * endpoints. Must be non-negative. */
	num_iso_packets: c.int,
	/** Isochronous packet descriptors, for isochronous transfers only. */
	// TODO
	//  iso_packet_desc[LIBUSB_FLEXIBLE_ARRAY]: libusb_iso_packet_descriptor,
}

/** \ingroup libusb_misc
 * Capabilities supported by an instance of libusb on the current running
 * platform. Test if the loaded library supports a given capability by calling
 * \ref libusb_has_capability().
 */
libusb_capability :: enum c.uint {
	/** The libusb_has_capability() API is available. */
	LIBUSB_CAP_HAS_CAPABILITY                = 0x0000,
	/** Hotplug support is available on this platform. */
	LIBUSB_CAP_HAS_HOTPLUG                   = 0x0001,
	/** The library can access HID devices without requiring user intervention.
	 * Note that before being able to actually access an HID device, you may
	 * still have to call additional libusb functions such as
	 * \ref libusb_detach_kernel_driver(). */
	LIBUSB_CAP_HAS_HID_ACCESS                = 0x0100,
	/** The library supports detaching of the default USB driver, using
	 * \ref libusb_detach_kernel_driver(), if one is set by the OS kernel */
	LIBUSB_CAP_SUPPORTS_DETACH_KERNEL_DRIVER = 0x0101,
}

/** \ingroup libusb_lib
 *  Log message levels.
 */
Log_Level :: enum c.int {
	/** (0) : No messages ever emitted by the library (default) */
	LIBUSB_LOG_LEVEL_NONE    = 0,
	/** (1) : Error messages are emitted */
	LIBUSB_LOG_LEVEL_ERROR   = 1,
	/** (2) : Warning and error messages are emitted */
	LIBUSB_LOG_LEVEL_WARNING = 2,
	/** (3) : Informational, warning and error messages are emitted */
	LIBUSB_LOG_LEVEL_INFO    = 3,
	/** (4) : All messages are emitted */
	LIBUSB_LOG_LEVEL_DEBUG   = 4,
}

/** \ingroup libusb_lib
 *  Log callback mode.
 *
 *  Since version 1.0.23, \ref LIBUSB_API_VERSION >= 0x01000107
 *
 * \see libusb_set_log_cb()
 */
libusb_log_cb_mode :: enum c.int {
	/** Callback function handling all log messages. */
	LIBUSB_LOG_CB_GLOBAL  = (1 << 0),
	/** Callback function handling context related log messages. */
	LIBUSB_LOG_CB_CONTEXT = (1 << 1),
}

/** \ingroup libusb_lib
 * Available option values for libusb_set_option() and libusb_init_context().
 */
libusb_option :: enum c.int {
	/** Set the log message verbosity.
	 *
	 * This option must be provided an argument of type \ref libusb_log_level.
	 * The default level is LIBUSB_LOG_LEVEL_NONE, which means no messages are ever
	 * printed. If you choose to increase the message verbosity level, ensure
	 * that your application does not close the stderr file descriptor.
	 *
	 * You are advised to use level LIBUSB_LOG_LEVEL_WARNING. libusb is conservative
	 * with its message logging and most of the time, will only log messages that
	 * explain error conditions and other oddities. This will help you debug
	 * your software.
	 *
	 * If the LIBUSB_DEBUG environment variable was set when libusb was
	 * initialized, this option does nothing: the message verbosity is fixed
	 * to the value in the environment variable.
	 *
	 * If libusb was compiled without any message logging, this option does
	 * nothing: you'll never get any messages.
	 *
	 * If libusb was compiled with verbose debug message logging, this option
	 * does nothing: you'll always get messages from all levels.
	 */
	LIBUSB_OPTION_LOG_LEVEL           = 0,
	/** Use the UsbDk backend for a specific context, if available.
	 *
	 * This option should be set at initialization with libusb_init_context()
	 * otherwise unspecified behavior may occur.
	 *
	 * Only valid on Windows. Ignored on all other platforms.
	 */
	LIBUSB_OPTION_USE_USBDK           = 1,
	/** Do not scan for devices
	 *
	 * With this option set, libusb will skip scanning devices in
	 * libusb_init_context().
	 *
	 * Hotplug functionality will also be deactivated.
	 *
	 * The option is useful in combination with libusb_wrap_sys_device(),
	 * which can access a device directly without prior device scanning.
	 *
	 * This is typically needed on Android, where access to USB devices
	 * is limited.
	 *
	 * This option should only be used with libusb_init_context()
	 * otherwise unspecified behavior may occur.
	 *
	 * Only valid on Linux. Ignored on all other platforms.
	 */
	LIBUSB_OPTION_NO_DEVICE_DISCOVERY = 2,
	/** Set the context log callback function.
	 *
	 * Set the log callback function either on a context or globally. This
	 * option must be provided an argument of type \ref libusb_log_cb.
	 * Using this option with a NULL context is equivalent to calling
	 * libusb_set_log_cb() with mode \ref LIBUSB_LOG_CB_GLOBAL.
	 * Using it with a non-NULL context is equivalent to calling
	 * libusb_set_log_cb() with mode \ref LIBUSB_LOG_CB_CONTEXT.
	 */
	LIBUSB_OPTION_LOG_CB              = 3,
	LIBUSB_OPTION_MAX                 = 4,
}

LIBUSB_OPTION_WEAK_AUTHORITY :: libusb_option.LIBUSB_OPTION_NO_DEVICE_DISCOVERY

/** \ingroup libusb_lib
	* Callback function for handling log messages.
	* \param ctx the context which is related to the log message, or NULL if it
	* is a global log message
	* \param level the log level, see \ref libusb_log_level for a description
	* \param str the log message
	*
	* Since version 1.0.23, \ref LIBUSB_API_VERSION >= 0x01000107
	*
	* \see libusb_set_log_cb()
	*/
libusb_log_cb :: proc(ctx: ^Libusb_Context, level: Log_Level, str: ^c.char)


/** \ingroup libusb_lib
 * Structure used for setting options through \ref libusb_init_context.
 *
 */
Init_Option :: struct {
	/** Which option to set */
	option: libusb_option,
	/** An integer value used by the option (if applicable). */
	value:  struct #raw_union {
		ival:      int,
		log_cbval: libusb_log_cb,
	},
}


/** \ingroup libusb_poll
	* Callback function, invoked when a new file descriptor should be added
	* to the set of file descriptors monitored for events.
	* \param fd the new file descriptor
	* \param events events to monitor for, see \ref libusb_pollfd for a
	* description
	* \param user_data User data pointer specified in
	* libusb_set_pollfd_notifiers() call
	* \see libusb_set_pollfd_notifiers()
	*/
libusb_pollfd_added_cb :: proc(fd: c.int, events: c.short, user_data: ^rawptr) -> rawptr

/** \ingroup libusb_poll
	* Callback function, invoked when a file descriptor should be removed from
	* the set of file descriptors being monitored for events. After returning
	* from this callback, do not use that file descriptor again.
	* \param fd the file descriptor to stop monitoring
	* \param user_data User data pointer specified in
	* libusb_set_pollfd_notifiers() call
	* \see libusb_set_pollfd_notifiers()
	*/
libusb_pollfd_removed_cb :: proc(fd: c.int, user_data: ^rawptr) -> rawptr

/** \ingroup libusb_hotplug
	* Hotplug callback function type. When requesting hotplug event notifications,
	* you pass a pointer to a callback function of this type.
	*
	* This callback may be called by an internal event thread and as such it is
	* recommended the callback do minimal processing before returning.
	*
	* libusb will call this function later, when a matching event had happened on
	* a matching device. See \ref libusb_hotplug for more information.
	*
	* It is safe to call either libusb_hotplug_register_callback() or
	* libusb_hotplug_deregister_callback() from within a callback function.
	*
	* Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
	*
	* \param ctx            context of this notification
	* \param device         libusb_device this event occurred on
	* \param event          event that occurred
	* \param user_data      user data provided when this callback was registered
	* \returns bool whether this callback is finished processing events.
	*                       returning 1 will cause this callback to be deregistered
	*/
libusb_hotplug_callback_fn :: proc(
	ctx: ^Libusb_Context,
	device: ^Device,
	event: libusb_hotplug_event,
	user_data: ^rawptr,
) -> ^c.int

@(default_calling_convention = "stdcall")
foreign lib {
	libusb_init :: proc(ctx: [^]^Libusb_Context) -> int ---
	libusb_init_context :: proc(ctx: [^]^Libusb_Context, options: []Init_Option, num_options: c.int) -> int ---
	libusb_exit :: proc(ctx: ^Libusb_Context) ---
	libusb_set_debug :: proc(ctx: ^Libusb_Context, level: c.int) ---

	/* may be deprecated in the future in favor of lubusb_init_context()+libusb_set_option() */
	libusb_set_log_cb :: proc(ctx: ^Libusb_Context, cb: libusb_log_cb, mode: c.int) ---
	libusb_get_version :: proc() -> ^Version ---
	libusb_has_capability :: proc(capability: c.uint32_t) -> c.int ---
	libusb_error_name :: proc(errcode: c.int) -> ^c.char ---
	libusb_setlocale :: proc(locale: ^c.char) -> c.int ---
	libusb_strerror :: proc(errcode: c.int) -> ^c.char ---

	libusb_get_device_list :: proc(ctx: ^Libusb_Context, list: ^[^]^Device) -> c.ssize_t ---
	libusb_free_device_list :: proc(list: [^]^Device, unref_devices: c.int) ---
	libusb_ref_device :: proc(dev: ^Device) -> ^Device ---
	libusb_unref_device :: proc(dev: ^Device) ---

	libusb_get_configuration :: proc(dev: Device_Handle, config: ^c.int) -> c.int ---
	libusb_get_device_descriptor :: proc(dev: ^Device, desc: ^device_descriptor) -> c.int ---
	libusb_get_active_config_descriptor :: proc(dev: ^Device, config: [^]^config_descriptor) -> c.int ---
	libusb_get_config_descriptor :: proc(dev: ^Device, config_index: c.uint8_t, config: [^]^config_descriptor) -> c.int ---
	libusb_get_config_descriptor_by_value :: proc(dev: ^Device, bConfigurationValue: c.uint8_t, config: [^]^config_descriptor) -> c.int ---
	libusb_free_config_descriptor :: proc(config: ^config_descriptor) ---
	libusb_get_ss_endpoint_companion_descriptor :: proc(ctx: ^Libusb_Context, endpoint: ^Endpoint_Descriptor, ep_comp: [^]^ss_endpoint_companion_descriptor) -> c.int ---
	libusb_free_ss_endpoint_companion_descriptor :: proc(ep_comp: ^ss_endpoint_companion_descriptor) ---
	libusb_get_bos_descriptor :: proc(dev_handle: ^Device_Handle, bos: [^]^bos_descriptor) -> c.int ---
	libusb_free_bos_descriptor :: proc(bos: ^bos_descriptor) ---
	libusb_get_usb_2_0_extension_descriptor :: proc(ctx: ^Libusb_Context, dev_cap: ^bos_dev_capability_descriptor, usb_2_0_extension: [^]^usb_2_0_extension_descriptor) -> c.int ---
	libusb_free_usb_2_0_extension_descriptor :: proc(usb_2_0_extension: ^usb_2_0_extension_descriptor) ---
	libusb_get_ss_usb_device_capability_descriptor :: proc(ctx: ^Libusb_Context, dev_cap: ^bos_dev_capability_descriptor, ss_usb_device_cap: [^]^ss_usb_device_capability_descriptor) -> c.int ---
	libusb_free_ss_usb_device_capability_descriptor :: proc(ss_usb_device_cap: ^ss_usb_device_capability_descriptor) ---
	libusb_get_container_id_descriptor :: proc(ctx: ^Libusb_Context, dev_cap: ^bos_dev_capability_descriptor, container_id: [^]^container_id_descriptor) -> c.int ---
	libusb_free_container_id_descriptor :: proc(container_id: ^container_id_descriptor) ---
	libusb_get_platform_descriptor :: proc(ctx: ^Libusb_Context, dev_cap: ^bos_dev_capability_descriptor, platform_descriptor: [^]^platform_descriptor) -> c.int ---
	libusb_free_platform_descriptor :: proc(platform_descriptor: ^platform_descriptor) ---
	libusb_get_bus_number :: proc(dev: ^Device) -> c.uint8_t ---
	libusb_get_port_number :: proc(dev: ^Device) -> c.uint8_t ---
	libusb_get_port_numbers :: proc(dev: ^Device, port_numbers: [^]c.uint8_t, port_numbers_len: c.int) -> c.int ---
	@(deprecated = "use libusb_get_port_numbers")
	libusb_get_port_path :: proc(ctx: ^Libusb_Context, dev: ^Device, path: ^c.uint8_t, path_length: c.uint8_t) -> c.int ---
	libusb_get_parent :: proc(dev: ^Device) -> Device ---
	libusb_get_device_address :: proc(dev: ^Device) -> c.uint8_t ---
	libusb_get_device_speed :: proc(dev: ^Device) -> c.int ---
	libusb_get_max_packet_size :: proc(dev: ^Device, endpoint: c.uchar) -> c.int ---
	libusb_get_max_iso_packet_size :: proc(dev: ^Device, endpoint: c.uchar) -> c.int ---
	libusb_get_max_alt_packet_size :: proc(dev: ^Device, interface_number: c.int, alternate_setting: c.int, endpoint: c.uchar) -> c.int ---

	libusb_get_interface_association_descriptors :: proc(dev: ^Device, config_index: c.uint8_t, iad_array: [^]^interface_association_descriptor_array) -> c.int ---
	libusb_get_active_interface_association_descriptors :: proc(dev: ^Device, iad_array: [^]^interface_association_descriptor_array) -> c.int ---
	libusb_free_interface_association_descriptors :: proc(iad_array: ^interface_association_descriptor_array) ---

	libusb_wrap_sys_device :: proc(ctx: ^Libusb_Context, sys_dev: c.intptr_t, dev_handle: [^]^Device_Handle) -> c.int ---
	libusb_open :: proc(dev: ^Device, dev_handle: [^]^Device_Handle) -> c.int ---
	libusb_close :: proc(dev_handle: ^Device_Handle) ---
	libusb_get_device :: proc(dev_handle: ^Device_Handle) -> ^Device ---

	libusb_set_configuration :: proc(dev_handle: ^Device_Handle, configuration: c.int) -> c.int ---
	libusb_claim_interface :: proc(dev_handle: ^Device_Handle, interface_number: c.int) -> c.int ---
	libusb_release_interface :: proc(dev_handle: ^Device_Handle, interface_number: c.int) -> c.int ---

	libusb_open_device_with_vid_pid :: proc(ctx: ^Libusb_Context, vendor_id: c.uint16_t, product_id: c.uint16_t) -> ^Device_Handle ---

	libusb_set_interface_alt_setting :: proc(dev_handle: ^Device_Handle, interface_number: c.int, alternate_setting: c.int) -> c.int ---
	libusb_clear_halt :: proc(dev_handle: ^Device_Handle, endpoint: c.uchar) -> c.int ---
	libusb_reset_device :: proc(dev_handle: ^Device_Handle) -> c.int ---

	libusb_alloc_streams :: proc(dev_handle: ^Device_Handle, num_streams: c.uint32_t, endpoints: ^c.uchar, num_endpoints: c.int) -> c.int ---
	libusb_free_streams :: proc(dev_handle: ^Device_Handle, endpoints: ^c.uchar, num_endpoints: c.int) -> c.int ---

	libusb_dev_mem_alloc :: proc(dev_handle: ^Device_Handle, length: c.size_t) -> ^c.uchar ---
	libusb_dev_mem_free :: proc(dev_handle: ^Device_Handle, buffer: ^c.uchar, length: c.size_t) -> c.int ---

	libusb_kernel_driver_active :: proc(dev_handle: ^Device_Handle, interface_number: c.int) -> c.int ---
	libusb_detach_kernel_driver :: proc(dev_handle: ^Device_Handle, interface_number: c.int) -> c.int ---
	libusb_attach_kernel_driver :: proc(dev_handle: ^Device_Handle, interface_number: c.int) -> c.int ---
	libusb_set_auto_detach_kernel_driver :: proc(dev_handle: ^Device_Handle, enable: c.int) -> c.int ---

	/* async I/O */

	libusb_alloc_transfer :: proc(iso_packets: c.int) -> ^Transfer ---
	libusb_submit_transfer :: proc(transfer: ^Transfer) -> c.int ---
	libusb_cancel_transfer :: proc(transfer: ^Transfer) -> c.int ---
	libusb_free_transfer :: proc(transfer: ^Transfer) ---
	libusb_transfer_set_stream_id :: proc(transfer: ^Transfer, stream_id: c.uint32_t) ---
	libusb_transfer_get_stream_id :: proc(transfer: ^Transfer) -> c.uint32_t ---

	/* sync I/O */

	libusb_control_transfer :: proc(dev_handle: ^Device_Handle, request_type: c.uint8_t, bRequest: c.uint8_t, wValue: c.uint16_t, wIndex: c.uint16_t, data: ^c.uchar, wLength: c.uint16_t, timeout: c.uint) -> c.int ---

	libusb_bulk_transfer :: proc(dev_handle: ^Device_Handle, endpoint: c.uchar, data: ^c.uchar, length: c.int, actual_length: ^c.int, timeout: c.uint) -> c.int ---
	libusb_interrupt_transfer :: proc(dev_handle: ^Device_Handle, endpoint: c.uchar, data: ^c.uchar, length: c.int, actual_length: ^c.int, timeout: c.uint) -> c.int ---

	/* polling and timeouts */

	libusb_try_lock_events :: proc(ctx: ^Libusb_Context) -> c.int ---
	libusb_lock_events :: proc(ctx: ^Libusb_Context) ---
	libusb_unlock_events :: proc(ctx: ^Libusb_Context) ---
	libusb_event_handling_ok :: proc(ctx: ^Libusb_Context) -> c.int ---
	libusb_event_handler_active :: proc(ctx: ^Libusb_Context) -> c.int ---
	libusb_interrupt_event_handler :: proc(ctx: ^Libusb_Context) ---
	libusb_lock_event_waiters :: proc(ctx: ^Libusb_Context) ---
	libusb_unlock_event_waiters :: proc(ctx: ^Libusb_Context) ---
	libusb_wait_for_event :: proc(ctx: ^Libusb_Context, tv: timeval) -> c.int ---

	libusb_handle_events_timeout :: proc(ctx: ^Libusb_Context, tv: timeval) -> c.int ---
	libusb_handle_events_timeout_completed :: proc(ctx: ^Libusb_Context, tv: timeval, completed: ^c.int) -> c.int ---
	libusb_handle_events :: proc(ctx: ^Libusb_Context) -> c.int ---
	libusb_handle_events_completed :: proc(ctx: ^Libusb_Context, completed: ^c.int) -> c.int ---
	libusb_handle_events_locked :: proc(ctx: ^Libusb_Context, tv: timeval) -> c.int ---
	libusb_pollfds_handle_timeouts :: proc(ctx: ^Libusb_Context) -> c.int ---
	libusb_get_next_timeout :: proc(ctx: ^Libusb_Context, tv: timeval) -> c.int ---

	libusb_get_pollfds :: proc(ctx: ^Libusb_Context) -> [^]^libusb_pollfd ---
	libusb_free_pollfds :: proc(pollfds: [^]^libusb_pollfd) ---
	libusb_set_pollfd_notifiers :: proc(ctx: ^Libusb_Context, added_cb: libusb_pollfd_added_cb, removed_cb: libusb_pollfd_removed_cb, user_data: ^rawptr) ---

	/** \ingroup libusb_hotplug
	* Register a hotplug callback function
	*
	* Register a callback with the libusb_context. The callback will fire
	* when a matching event occurs on a matching device. The callback is
	* armed until either it is deregistered with libusb_hotplug_deregister_callback()
	* or the supplied callback returns 1 to indicate it is finished processing events.
	*
	* If the \ref LIBUSB_HOTPLUG_ENUMERATE is passed the callback will be
	* called with a \ref LIBUSB_HOTPLUG_EVENT_DEVICE_ARRIVED for all devices
	* already plugged into the machine. Note that libusb modifies its internal
	* device list from a separate thread, while calling hotplug callbacks from
	* libusb_handle_events(), so it is possible for a device to already be present
	* on, or removed from, its internal device list, while the hotplug callbacks
	* still need to be dispatched. This means that when using \ref
	* LIBUSB_HOTPLUG_ENUMERATE, your callback may be called twice for the arrival
	* of the same device, once from libusb_hotplug_register_callback() and once
	* from libusb_handle_events(); and/or your callback may be called for the
	* removal of a device for which an arrived call was never made.
	*
	* Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
	*
	* \param[in] ctx context to register this callback with
	* \param[in] events bitwise or of hotplug events that will trigger this callback.
	*            See \ref libusb_hotplug_event
	* \param[in] flags bitwise or of hotplug flags that affect registration.
	*            See \ref libusb_hotplug_flag
	* \param[in] vendor_id the vendor id to match or \ref LIBUSB_HOTPLUG_MATCH_ANY
	* \param[in] product_id the product id to match or \ref LIBUSB_HOTPLUG_MATCH_ANY
	* \param[in] dev_class the device class to match or \ref LIBUSB_HOTPLUG_MATCH_ANY
	* \param[in] cb_fn the function to be invoked on a matching event/device
	* \param[in] user_data user data to pass to the callback function
	* \param[out] callback_handle pointer to store the handle of the allocated callback (can be NULL)
	* \returns \ref LIBUSB_SUCCESS on success LIBUSB_ERROR code on failure
	*/
	libusb_hotplug_register_callback :: proc(ctx: ^Libusb_Context, events: c.int, flags: c.int, vendor_id: c.int, product_id: c.int, dev_class: c.int, cb_fn: libusb_hotplug_callback_fn, user_data: ^rawptr, callback_handle: ^libusb_hotplug_callback_handle) -> c.int ---

	/** \ingroup libusb_hotplug
	* Deregisters a hotplug callback.
	*
	* Deregister a callback from a libusb_context. This function is safe to call from within
	* a hotplug callback.
	*
	* Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
	*
	* \param[in] ctx context this callback is registered with
	* \param[in] callback_handle the handle of the callback to deregister
	*/
	libusb_hotplug_deregister_callback :: proc(ctx: ^Libusb_Context, callback_handle: libusb_hotplug_callback_handle) ---

	/** \ingroup libusb_hotplug
	* Gets the user_data associated with a hotplug callback.
	*
	* Since version v1.0.24 \ref LIBUSB_API_VERSION >= 0x01000108
	*
	* \param[in] ctx context this callback is registered with
	* \param[in] callback_handle the handle of the callback to get the user_data of
	*/
	libusb_hotplug_get_user_data :: proc(ctx: ^Libusb_Context, callback_handle: libusb_hotplug_callback_handle) -> rawptr ---

	// TODO
	// libusb_set_option::proc(ctx: ^Libusb_Context, enum libusb_option option, ...) -> c.int ---
}

/** \ingroup libusb_poll
 * File descriptor for polling
 */
libusb_pollfd :: struct {
	/** Numeric file descriptor */
	fd:     c.int,
	/** Event flags to poll for from <poll.h>. POLLIN indicates that you
	 * should monitor this file descriptor for becoming ready to read from,
	 * and POLLOUT indicates that you should monitor this file descriptor for
	 * nonblocking write readiness. */
	events: c.short,
}


/** \ingroup libusb_hotplug
 * Callback handle.
 *
 * Callbacks handles are generated by libusb_hotplug_register_callback()
 * and can be used to deregister callbacks. Callback handles are unique
 * per libusb_context and it is safe to call libusb_hotplug_deregister_callback()
 * on an already deregistered callback.
 *
 * Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
 *
 * For more information, see \ref libusb_hotplug.
 */
libusb_hotplug_callback_handle :: c.int

/** \ingroup libusb_hotplug
 *
 * Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
 *
 * Hotplug events */
libusb_hotplug_event :: enum c.int {
	/** A device has been plugged in and is ready to use */
	LIBUSB_HOTPLUG_EVENT_DEVICE_ARRIVED = (1 << 0),
	/** A device has left and is no longer available.
	 * It is the user's responsibility to call libusb_close on any handle associated with a disconnected device.
	 * It is safe to call libusb_get_device_descriptor on a device that has left */
	LIBUSB_HOTPLUG_EVENT_DEVICE_LEFT    = (1 << 1),
}

/** \ingroup libusb_hotplug
 *
 * Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
 *
 * Hotplug flags */
libusb_hotplug_flag :: enum c.int {
	/** Arm the callback and fire it for all matching currently attached devices. */
	LIBUSB_HOTPLUG_ENUMERATE = (1 << 0),
}

/** \ingroup libusb_hotplug
 * Convenience macro when not using any flags */
LIBUSB_HOTPLUG_NO_FLAGS :: 0

/** \ingroup libusb_hotplug
 * Wildcard matching for hotplug events */
LIBUSB_HOTPLUG_MATCH_ANY :: -1
