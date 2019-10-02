// BEGIN NST_training_1
import turicreate as tc

# Configure as required
style_images_directory = 'style/'
content_images_directory = 'content/'
training_cycles_to_perform = 6000
output_model_filename = 'StyleTransferModel'
output_image_constraints = (800, 800)

# Load the style and content images
styles = tc.load_images(style_images_directory)
content = tc.load_images(content_images_directory)

# Create a StyleTransfer model
model = tc.style_transfer.create(styles, content,
    max_iterations=training_cycles_to_perform)

# Export for use in Core ML
model.export_coreml(output_model_filename + '.mlmodel',
    image_shape=output_image_constraints)
// END NST_training_1