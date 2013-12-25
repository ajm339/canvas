# A sample Guardfile
# More info at https://github.com/guard/guard#readme

require 'active_support/core_ext'

require 'rbconfig'

def os
  @os ||= (
           host_os = RbConfig::CONFIG['host_os']
           case host_os
           when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
             :windows
           when /darwin|mac os/
             :macosx
           when /linux/
             :linux
           when /solaris|bsd/
             :unix
           else
             raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
           end
           )
end

puts os

if os == :macosx
  guard 'livereload', grace_period: 0 do
    watch(%r{app/views/.+\.(erb|haml|slim)$})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{public/.+\.(css|js|html)})
    watch(%r{config/locales/.+\.yml})
    # Rails Assets Pipeline
    watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
  end
end