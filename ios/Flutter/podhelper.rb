# This file is used to help CocoaPods integrate with Flutter.

def parse_KV_file(file, separator='=')
  file_abs_path = File.expand_path(file)
  if !File.exist?(file_abs_path)
    return []
  end
  file_lines = File.read(file_abs_path).split("\n")
  return file_lines.map { |line| line.strip.split(separator) }.reject { |kv| kv.length != 2 }.map { |kv| [kv[0], kv[1]] }.to_h
end

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', '..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter build is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter build again."
end

def flutter_ios_podfile_setup
  generated_xcode_build_settings_path = File.expand_path(File.join('..', '..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter build is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_FRAMEWORK_DIR\=(.*)/)
    if matches
      framework_dir = matches[1].strip
      pod 'Flutter', :path => framework_dir
    end
  end
end

def flutter_install_all_ios_pods(flutter_application_path = nil)
  if flutter_application_path.nil?
    flutter_application_path = File.join('..', '..')
  end

  # Keep pod path relative so it can be checked into Podfile.lock.
  relative = flutter_application_path
  unless flutter_application_path.start_with?('/')
    relative = File.join('..', flutter_application_path)
  end

  pod 'Flutter', :path => File.join(relative, '.ios', 'Flutter')
  pod 'FlutterPluginRegistrant', :path => File.join(relative, '.ios', 'Flutter', 'FlutterPluginRegistrant')

  # Read .flutter-plugins-dependencies file
  plugin_pods = parse_KV_file(File.join(flutter_application_path, '.flutter-plugins-dependencies'))
  plugin_pods.each do |name, path|
    pod name, :path => File.join(flutter_application_path, path)
  end
end
