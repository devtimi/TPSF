#tag Module
Protected Module TPSF
	#tag Method, Flags = &h1
		Protected Function AppParent() As FolderItem
		  return App.ExecutableFile.Parent
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function AppSupport() As FolderItem
		  Dim rValue as folderitem = SpecialFolder.ApplicationData
		  #if TargetMacOS then
		    if rValue <> nil then rvalue = rvalue.child(app.BundleIdentifier)
		  #elseif TargetWin32 then
		    dim appName as String = ReplaceAll(App.ExecutableFile.Name, ".exe", "")
		    if rValue <> nil then rvalue = rvalue.child(appName)
		  #endif
		  
		  Return rvalue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BundleIdentifier(Extends a as Application) As String
		  #pragma unused a
		  static mBundleIdentifier as string
		  
		  #if TargetMacOS
		    if mBundleIdentifier = "" then
		      declare function mainBundle lib "AppKit" selector "mainBundle" ( NSBundleClass as Ptr ) as Ptr
		      declare function NSClassFromString lib "AppKit" ( className as CFStringRef ) as Ptr
		      declare function getValue lib "AppKit" selector "bundleIdentifier" ( NSBundleRef as Ptr ) as CfStringRef
		      mBundleIdentifier = getValue( mainBundle( NSClassFromString( "NSBundle" ) ) )
		    end if
		  #endif
		  
		  return mBundleIdentifier
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function BundleParent() As FolderItem
		  #if TargetMacOS then
		    static mBundlePath as folderitem
		    
		    if mBundlePath = nil or mBundlePath.exists = false then
		      declare function NSClassFromString lib "AppKit" ( className as CFStringRef ) as Ptr
		      declare function mainBundle lib "AppKit" selector "mainBundle" ( NSBundleClass as Ptr ) as Ptr
		      declare function resourcePath lib "AppKit" selector "bundlePath" ( NSBundleRef as Ptr ) as CfStringRef
		      mBundlePath = getFolderItem( resourcePath( mainBundle( NSClassFromString( "NSBundle" ) ) ), folderItem.pathTypeNative )
		    end if
		    
		    return mBundlePath
		    
		  #elseif TargetWin32 then
		    return App.ExecutableFile.Parent
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Contents() As FolderItem
		  #if TargetMacOS then
		    return App.ExecutableFile.Parent.Parent
		  #elseif TargetWin32 then
		    return App.ExecutableFile.Parent
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Frameworks() As FolderItem
		  #if TargetMacOS then
		    static mFrameworks as folderitem
		    
		    if mFrameworks = nil or mFrameworks.exists = false then
		      declare function NSClassFromString lib "AppKit" ( className as CFStringRef ) as Ptr
		      declare function mainBundle lib "AppKit" selector "mainBundle" ( NSBundleClass as Ptr ) as Ptr
		      declare function resourcePath lib "AppKit" selector "privateFrameworksPath" ( NSBundleRef as Ptr ) as CfStringRef
		      mFrameworks = getFolderItem( resourcePath( mainBundle( NSClassFromString( "NSBundle" ) ) ), folderItem.pathTypeNative )
		    end if
		    
		    return mFrameworks
		    
		  #elseif TargetWin32 then
		    dim libsFolder as FolderItem = App.ExecutableFile.Parent.Child("Libs")
		    if libsFolder.Exists then
		      return libsFolder
		    else
		      dim pathStringVar as String = App.ExecutableFile.NativePath
		      pathStringVar = pathStringVar.Left(pathStringVar.Len - 4) + " Libs"
		      return GetFolderItem(pathStringVar)
		    end
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Resources() As FolderItem
		  #if TargetMacOS then
		    static mResourcesFolder as folderitem
		    
		    if mResourcesFolder = nil or mResourcesFolder.exists = false then
		      declare function NSClassFromString lib "AppKit" ( className as CFStringRef ) as Ptr
		      declare function mainBundle lib "AppKit" selector "mainBundle" ( NSBundleClass as Ptr ) as Ptr
		      declare function resourcePath lib "AppKit" selector "resourcePath" ( NSBundleRef as Ptr ) as CfStringRef
		      mResourcesFolder = getFolderItem( resourcePath( mainBundle( NSClassFromString( "NSBundle" ) ) ), folderItem.pathTypeNative )
		    end if
		    
		    return mResourcesFolder
		    
		  #elseif TargetWin32 then
		    dim rsrcFolder as FolderItem = App.ExecutableFile.Parent.Child("Resources")
		    if rsrcFolder.Exists then
		      return rsrcFolder
		    else
		      dim pathStringVar as String = App.ExecutableFile.NativePath
		      pathStringVar = pathStringVar.Left(pathStringVar.Len - 4) + " Resources"
		      return GetFolderItem(pathStringVar)
		    end
		  #endif
		End Function
	#tag EndMethod


	#tag Note, Name = About
		This module makes it easier to access executable relative files since Xojo does not include a SepcialFolder.Resources or the like.
		Very large thanks to Sam Rowlands for help with the Mac declares.
		
		Access "Copy Files" build step folders like:
		TPSF.AppParent()
		TPSF.BundleParent()
		TPSF.Contents()
		TPSF.Frameworks()
		TPSF.Resources()
		
		Direct access to your own Application Support folder:
		TPSF.AppSupport()
		
		Mac: ~/Library/Application Support/[bundle identifier]
		Win: \Users\[user]\AppData\Roaming\[app name]
		
		On Mac you can get your bundle identifier (via proper Cocoa declares) as an extension of Application,
		on Windows this returns an empty string.
		App.BundleIdentifier
		
	#tag EndNote


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
