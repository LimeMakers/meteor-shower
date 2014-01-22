fs = require 'fs'
shell = require 'shelljs'

module.exports = patch: (cls) ->
    cls::install = ->
        return unless @config.packages?
        for package_name, options of @config.packages
            if fs.existsSync "#{@root}/packages/#{package_name}"
                console.log "#{package_name} already installed; updating not yet implemented"
            else
                switch options.from
                    when 'git'
                        unless shell.which 'git'
                            throw new RunError 'You don\'t seem to have git in your system. Please install it.'
                        console.log "installing #{package_name} from git: #{options.remote}"
                        shell.exec "git clone --recursive #{options.remote} #{@root}/packages/#{package_name}"
                        if options.ref?
                            shell.pushd "#{@root}/packages/#{package_name}"
                            shell.exec "git checkout #{options.ref}"
                            shell.popd()
                    when 'bzr'
                        unless shell.which 'bzr'
                            throw new RunError 'You don\'t seem to have bzr in your system. Please install it.'
                        console.log "installing #{package_name} from bzr: #{options.branch}"
                        shell.exec "bzr branch #{options.branch} #{@root}/packages/#{package_name}"
                    when 'archive', 'atmosphere'
                        console.log "Sorry, installing from #{options.from} not yet implemented"
                    else
                        throw new RunError "Unknown installation method #{options.from}"
