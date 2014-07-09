module.exports = (g) ->

  g.loadNpmTasks 'grunt-jasmine-bundle'
  g.loadNpmTasks 'grunt-browserify'

  g.initConfig
    browserify:
      build:
        src: ['./client.js']
        dest: 'bus.io.js'
        options:
          bundleOptions:
            standalone: 'client'
    spec:
      unit:
        options:
          helpers: 'spec/helpers/**/*.{js,coffee}'
          specs: 'spec/**/*.{js,coffee}'
      e2e:
        options:
          helpers: 'spec-e2e/helpers/**/*.{js,coffee}'
          specs: 'spec-e2e/**/*.{js,coffee}'

  g.registerTask 'default', ['spec:unit', 'spec:e2e']
  g.registerTask 'build', ['browserify:build']
