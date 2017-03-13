Pod::Spec.new do |spec|
  spec.name = "AppShare"
  spec.version = "0.3.0"
  spec.summary = "A simple yet powerful App Sharing Manager for iOS in Swift 3. Get your App viral now."
  spec.description = <<-DESC
    A simple yet powerful App Sharing Manager for iOS in Swift.
    * 100% Swift 3
    * Fully Configurable at Runtime
    * Default Localizations for Dozens of Languages
    * Easy to Setup
  DESC
  spec.homepage = "https://github.com/grizzly/AppShare"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Grizzly" => 'st.mayr@grizzlynt.com' }

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/grizzly/AppShare.git", tag: "#{spec.version}", submodules: true }
  spec.source_files = "AppShare/**/*.{h,swift}"
  spec.ios.resource_bundle = { 'AppShare' => ['Localization/*.lproj'] }
end
