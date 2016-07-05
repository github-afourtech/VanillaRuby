#Before do |scenario|
#
#end
#
#After do |scenario|
#
#  if scenario.failed?
#    $LOG.info "Add screenshot, if the scenario failed"
#      $driver.save_screenshot("log/webscreenshot/webScreenshot_#{$webscreenshot}.png")
#    embed("webScreenshot_#{$webscreenshot}.png", "image/png")
#    $webscreenshot = $webscreenshot + 1
#  end
#end