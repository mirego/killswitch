# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('vendor/assets/fonts')

# Make sure we precompile vendor font assets
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

# Make sure we compile other top-level assets
Rails.application.config.assets.precompile += %w(
  vendor.js
)
