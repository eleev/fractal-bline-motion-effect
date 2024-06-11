# Metal shader for FBM-based pattern generation [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

[![Platform](https://img.shields.io/badge/platform-iOS_17-yellow.svg)]()
[![Platform](https://img.shields.io/badge/platform-iPadOS_17-darkyellow.svg)]()
[![Language](https://img.shields.io/badge/language-Swift_5.10-orange.svg)]()
[![Last Commit](https://img.shields.io/github/last-commit/eleev/fractal-bline-motion)]()
[![NLOC](https://img.shields.io/tokei/lines/github/eleev/fractal-bline-motion)]()
[![Contributors](https://img.shields.io/github/contributors/eleev/fractal-bline-motion)]()
[![Repo Size](https://img.shields.io/github/repo-size/eleev/fractal-bline-motion)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()

<!-- ![](cover.png) -->

### If you like the project, please give it a star ⭐ It will show the creator your appreciation and help others to discover the repo.

# ✍️ About
🪄 **Metal shader** for Fractal Brownian Motion to generate animated glowing patterns from lines.

# 📺 Demo
Please note that the `.gif` files have low frame rate due to compression and accessibility of demo.

![](Assets/demo.gif)

# 🏗️ Approach
This Metal shader leverages procedural noise and Fractal Brownian Motion (fbm) to generate dynamic and visually appealing animated colored lines. The core functionality of the shader is broken down into several key components that work together to create smooth transitions and natural-looking patterns. 

The initial part starts from a hashing function.The hashing function is crucial for generating deterministic pseudo-random values. It operates by:
- Taking the dot product of the input vector with a fixed vector of constants.
- Calculating the sine of the resulting value.
- Scaling the sine value by a large constant and extracting the fractional part of this product. This fractional part serves as the pseudo-random number, constrained within the range [0, 1).

The next stage is noise function. The noise function is responsible for producing smoothly interpolated random values. It achieves this through the following steps:
- Dividing the input coordinates into their integer and fractional components.
- Applying a fade curve to the fractional parts to ensure smooth transitions between noise values.
- Generating hash values for the cell corners surrounding the point.
- Using the fade curve to interpolate these hash values, resulting in seamless transitions and continuous noise values.

This Metal shader utilizes procedural noise, hashing functions, and Fractal Brownian Motion (fbm) to create intricate and dynamic animated patterns of colored lines. Initially, the hashing function deterministically generates pseudo-random values by performing a dot product of the input vector with a fixed vector, applying a sine function, scaling the result by a large constant, and extracting the fractional part. The noise function further processes these values by splitting input coordinates into integer and fractional parts, applying a fade curve to the fractional parts, generating hash values for surrounding cell corners, and interpolating these values for smooth transitions.

Building on this, the fbm function creates complex and natural textures by initializing a result value to zero and adding noise values at varying frequencies (octaves), scaled by corresponding amplitudes from an amplitude vector. These scaled noise values are then combined to produce the final fbm value, with the summation of different frequencies and amplitudes yielding intricate patterns used in applications like terrain and cloud rendering.

The shader's visual pattern generation involves drawing animated colored lines influenced by procedural noise and fbm. This process is accomplished via multiple iterations, each iteration enhancing complexity through noise influences. The results from these iterations are combined to form a dynamic and aesthetically pleasing final pattern.

Operationally, the shader runs in two main loops. The first loop generates initial sets of colored lines through several iterations, while the second loop refines and combines these lines, influenced by noise and fbm, to produce the final animated visual pattern. By executing these processes, the shader achieves natural-looking textures and smooth transitions suitable for a variety of procedural texture applications.

# 👨‍💻 Author 
[Astemir Eleev](https://github.com/eleev)

# 🔖 Licence 
The project is available under [MIT Licence](https://github.com/eleev/swiftui-new-metal-shaders/blob/master/LICENSE)
