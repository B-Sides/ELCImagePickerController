# ELCImagePickerController

*A clone of the UIImagePickerController using the Assets Library Framework allowing for multiple asset selection.*

## Usage

The image picker is created and displayed in a very similar manner to the `UIImagePickerController`. The sample application  shows its use. To display the controller you instantiate it and display it modally like so.

```obj-c
// Create the image picker
ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] init];
imagePicker.maximumImagesCount = 4; //Set the maximum number of images to select, defaults to 4
imagePicker.imagePickerDelegate = self;

//Present modally
[self presentViewController:elcPicker animated:YES completion:nil];

// Release if not using ARC
[imagePicker release];
```

The `ELCImagePickerController` will return the select images back to the `ELCImagePickerControllerDelegate`. The delegate contains methods very similar to the `UIImagePickerControllerDelegate`. Instead of returning one dictionary representing a single image the controller sends back an array of similarly structured dictionaries. The two delegate methods are:

```obj-c
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;
```

The Image Picker allows for some customization, including limiting 
    to just one photo album, limiting to single image selection, and automatically
    scrolling to the bottom. See the demo viewcontroller for example usage.

## License

The MIT License

Copyright (c) 2010 ELC Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
