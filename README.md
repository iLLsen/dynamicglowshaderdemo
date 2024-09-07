## How to Set Up the Shader

### Create Sprite:
- Add a `Sprite2D` node and assign a texture to it.

### Create Inverted Sprite:
- Add another `Sprite2D` node.
- Assign the inverted texture to this sprite.
- Apply the shader material to this inverted sprite.

### Ensure Both Sprites are Aligned:
- Position the inverted sprite exactly on top of the original sprite.

### Configure the Shader Parameters:
- Adjust the `glow_position`, `glow_size`, `glow_strength`, `glow_intensity`, and other parameters to fit your new sprite.
- If you want the glow to pulsate, set the `pulsate` parameter to `true` and configure the `pulsation_speed`, `glow_intensity_start`, and `glow_intensity_stop` parameters.
