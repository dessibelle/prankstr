def import_pods
    pod 'CocoaAsyncSocket', '~> 7.4'
end


target :ios do
    platform :ios, '8.0'
    link_with 'prankstr'
    import_pods
end

target :osx do
    platform :osx, '10.10'
    link_with 'prankstrd', 'prankstrctl'
    import_pods
end
