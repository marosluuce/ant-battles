exports.config = {
  files: {
    javascripts: {
      joinTo: {
        "js/app.js": 'web/static/**/*.js'
      }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        after: ["web/static/css/app.css"]
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    assets: /^(web\/static\/assets)/
  },

  paths: {
    watched: [
      "web/static",
      "test/static",
      "web/elm"
    ],

    public: "priv/static"
  },

  plugins: {
    babel: {
      ignore: [/web\/static\/vendor/]
    },
    elmBrunch: {
      executablePath: '../../node_modules/elm/binwrappers',
      elmFolder: 'web/elm',
      mainModules: ['src/Main.elm'],
      outputFolder: '../../priv/static/js',
      outputFile: 'elm.js',
      makeParameters : ['--warn']
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true
  }
};
