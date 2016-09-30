Pod::Spec.new do |s|
  s.name         = "PTCalendarPicker"
  s.version      = "0.0.1"
  s.summary      = "日历弹出框控件"
  s.homepage     = "https://github.com/PerTerbin/PTCalendarPicker"
  s.license      = "MIT"
  s.author       = { "PerTerbin" => "474213894@qq.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/PerTerbin/PTCalendarPicker.git"}
  s.source_files = "PTCalendarPicker/PTCalendarPickerView/*.swift"
  s.resources    = "PTCalendarPicker/PTCalendarPickerView/Resources/*.png"
end
