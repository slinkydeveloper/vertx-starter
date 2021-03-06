<main>
  <div if={ tool } class="container">
    <div class="help-tip hide-phone">
      <p>
        The build tool can be changed using the hamburger menu on the left. For more information about this tool please visit <a href="{ tool.url }">{ tool.id }</a> website.<br><br>
        This is a progressive webapp, meaning that you can add it to your desktop and it can even run offline. You can boostrap your project even on the go without internet!
      </p>
    </div>
    <h1>{ tool.id }: { tool.file }</h1>
    <form onsubmit={ generate }>
      <!-- Basic fields -->
      <div each={ f, i in tool.fields } class="row">
        <!-- iterate 2 at a time -->
        <virtual if={ i % 2 === 0 }>
          <div class="col-6">
            <input name="{ tool.fields[i].key }" type="{ tool.fields[i].checkbox ? 'checkbox' : 'text' }" placeholder="{ tool.fields[i].label + (tool.fields[i].prefill ? ' e.g.: ' + tool.fields[i].prefill : '') }" required="{ tool.fields[i].required }">
            <label if={ tool.fields[i].checkbox }><br><i>{ tool.fields[i].label + (tool.fields[i].prefill ? ' e.g.: ' + tool.fields[i].prefill : '') }</i></label>
          </div>
          <div class="col-6">
            <!-- if there is a next one -->
            <input if={ tool.fields[i+1] }  name="{ tool.fields[i+1].key }" type="{ tool.fields[i+1].checkbox ? 'checkbox' : 'text' }" placeholder="{ tool.fields[i+1].label + (tool.fields[i+1].prefill ? ' e.g.: ' + tool.fields[i+1].prefill : '') }" required="{ tool.fields[i+1].required }">
            <label if={ tool.fields[i+1] && tool.fields[i+1].checkbox }><br><i>{ tool.fields[i+1].label + (tool.fields[i+1].prefill ? ' e.g.: ' + tool.fields[i+1].prefill : '') }</i></label>
          </div>
        </virtual>
      </div>

      <div if={ tool.languages || presets } class="row">
        <!-- language selection -->
        <div class="col-6">
          <select id="language" disabled="{ !tool.languages || tool.languages.length == 0 }" onchange={ changeLanguage }>
            <option each={ tool.languages } value="{ id }">{ id }</option>
          </select>
        </div>
        <!-- preset selection -->
        <div class="col-6">
          <select id="preset" disabled="{ !presetGroups || presetGroups.length == 0 }" onchange={ changePreset}>
            <option value="">Empty Project</option>
            <optgroup each={ g, i in presetGroups } label="{ i }">
              <option each={ g } value="{ id }">{ id }</option>
            </optgroup>
          </select>
        </div>
      </div>

      <div if={ preset.fields } class="row">
        <h5>Extra variables for { preset.id }:</h5>
      </div>

      <div each={ f, i in preset.fields } class="row">
        <!-- iterate 2 at a time -->
        <virtual if={ i % 2 === 0 }>
          <div class="col-6">
            <input name="{ preset.fields[i].key }" type="text" placeholder="{ preset.fields[i].label + (preset.fields[i].prefill ? ' e.g.: ' + preset.fields[i].prefill : '') }" required="{ preset.fields[i].required }">
          </div>
          <div class="col-6">
            <!-- if there is a next one -->
            <input if={ preset.fields[i+1] }  name="{ preset.fields[i+1].key }" type="text" placeholder="{ preset.fields[i+1].label + (preset.fields[i+1].prefill ? ' e.g.: ' + preset.fields[i+1].prefill : '') }" required="{ preset.fields[i+1].required }">
          </div>
        </virtual>
      </div>

      <div class="row">
        <div class="col-6">
          <h1>Dependencies</h1>
        </div>
        <div class="col-6">
          <div id="not-found-tip" class="help-tip hide-phone">
            <p>Use this box to search for dependencies to add to your application, if a dependency is not present, please <a href="https://github.com/pmlopes/vertx-starter/issues/new">open an issue</a> so we can add the missing metadata!</p>
          </div>
          <input type="text" class="pull-right" placeholder="Search dependency..." onkeyup={ search }>
        </div>
      </div>

      <div each={ c, i in dependencies } class="row">
        <!-- iterate 2 at a time -->
        <virtual if={ i % 2 == 0 }>
          <div class="col-6">
            <div class={ dependency: dependencies[i].checked }>
              <input name="dependencies" type="checkbox" value="{ i }" checked="{ dependencies[i].checked }" onclick={ toggleDependency }>
              <div>
                <span if={ dependencies[i].stack } class="pull-right"><img src="img/stack.svg" width="16px" /></span>
                <strong>{ dependencies[i].artifactId }</strong>
                <hr/>
                <p if={ dependencies[i].description }>{ dependencies[i].description }</p>
              </div>
              <br/>
            </div>
          </div>
          <div class="col-6">
            <!-- if there is a next one -->
            <div if={ dependencies[i+1] } class={ dependency: dependencies[i+1].checked }>
              <input name="dependencies" type="checkbox" value="{ i+1 }" checked="{ dependencies[i+1].checked }" onclick={ toggleDependency }>
              <div>
                <span if={ dependencies[i+1].stack } class="pull-right"><img src="img/stack.svg" width="16px" /></span>
                <strong>{ dependencies[i+1].artifactId }</strong>
                <hr/>
                <p if={ dependencies[i+1].description }>{ dependencies[i+1].description }</p>
              </div>
              <br/>
            </div>
          </div>
        </virtual>
      </div>
      <div if={ notfound } class="row center">
        <i>Sorry! Cannot find what you're looking for, please &nbsp;<a href="https://github.com/pmlopes/vertx-starter/issues/new">open an issue</a>&nbsp; so we know about the missing metadata!</i>
      </div>

      <div class="row" id="interaction">
        <div class="col-8">
          <button name="submit" type="submit">Generate</button>
          &nbsp;
          <a id="download-btn" onclick={ clean } href="#" show={ downloading } ref="download" download="{ name }.zip" style="padding: 1.1rem 3.5rem; margin: 1rem 0; background: #782b90; color: #f5f5f5; border-radius: 2px; border: none; font-size: 1.3rem; transition: all .2s ease">Download</a>
        </div>
        <div class="col-4">
          <div if={ generating } class="spinner">
            <div class="rect1"></div>
            <div class="rect2"></div>
            <div class="rect3"></div>
            <div class="rect4"></div>
            <div class="rect5"></div>
          </div>
        </div>
      </div>
    </form>

    <div class="row">
      <div class="center">
        <span>powered with <span style="color:#f00000">&lt;3</span> by <a href="https://github.com/pmlopes/vertx-starter/tree/gh-pages">github.com</a></span>
      </div>
    </div>
  </div>

  <script>
    var self = this;

    var r = route.create();
    // bind to the right route
    opts.buildtools.forEach(function (el) {
      r(el.id + '..', show.bind(self, el));
    });

    // show default route
    r(show.bind(self, self.opts.buildtools[0]));

    function show(tool) {
      var q = route.query();
      // parse initial values
      var setup = {
        dependencies: decodeURIComponent(q.dependencies || '').split(',')
      };

      if (tool.languages) {

        // track what project type is being generated
        ga('send', {
          hitType: 'event',
          eventCategory: tool.id + ':view',
          eventAction: tool.id + '/view',
          eventLabel: 'project'
        });

        var selection = [];

        // reset the dependencies
        opts.components.forEach(function (el, index) {
          var c;
          // check if initial setup requested this dependency
          if (setup.dependencies.indexOf(el.groupId + ':' + el.artifactId + (el.classifier ? ':' + el.classifier : '')) !== -1) {
            c = clone(el);
            c.checked = true;
            c.id = index;
            selection.push(c);
            return;
          }
          if (setup.dependencies.indexOf(el.groupId + ':' + el.artifactId) !== -1) {
            c = clone(el);
            c.checked = true;
            c.id = index;
            selection.push(c);
            return;
          }
          // unless it is a default for the tool
          if (tool.defaults.indexOf(el.groupId + ':' + el.artifactId + (el.classifier ? ':' + el.classifier : '')) !== -1) {
            c = clone(el);
            c.checked = true;
            c.id = index;
            selection.push(c);
            return;
          }
          if (tool.defaults.indexOf(el.groupId + ':' + el.artifactId) !== -1) {
            c = clone(el);
            c.checked = true;
            c.id = index;
            selection.push(c);
            return;
          }
        });

        var filteredPresets = filterPresets(tool.id, tool.languages[0].id);
        var filteredPresetsGroups = {};
        filteredPresets.forEach(function (el) {
          if (!filteredPresetsGroups[el.group]) {
            filteredPresetsGroups[el.group] = [];
          }
          filteredPresetsGroups[el.group].push(el);
        });

        self.update({
          // state change, disable old download
          downloading: false,
          tool: tool,
          // defaults to the first language of the list
          presets: filteredPresets,
          presetGroups: filteredPresetsGroups,
          language: tool.languages[0],
          dependencies: selection
        });
      } else {
        self.update({
          // state change, disable old download
          downloading: false,
          tool: tool,
          dependencies: []
        });
      }
    }

    function filterPresets(tool, lang) {
      return opts.presets.filter(function (el) {
        if (el.languages) {
          var l = el.languages.filter(function (e) {
            return e.id === lang;
          });

          if (l.length === 0) {
            return false;
          }
          if (el.buildtool) {
            return el.buildtool === tool;
          }
        } else {
          if (el.buildtool) {
            return el.buildtool === tool;
          }
        }
        return true;
      });
    }

    //Finds y value of given object
    function findPos(obj) {
      var curtop = 0;
      if (obj.offsetParent) {
        do {
          curtop += obj.offsetTop;
          // go to child
          obj = obj.offsetParent;
        } while (obj);
        return [curtop];
      }
    }

    this.changeLanguage = function (e) {
      // carry on with the task...
      e.preventDefault();
      var oldLang = self.language;
      var newLang = self.tool.languages.filter(function (el) {
        return el.id === e.target.value;
      })[0];

      ga('send', {
        hitType: 'event',
        eventCategory: newLang.id + ':view',
        eventAction: newLang.id + '/view',
        eventLabel: 'project'
      });

      // reset
      var selection = [].concat(self.dependencies);

      // exclude old lang support
      if (oldLang) {
        for (var index = 0; index < selection.length; index++) {
          var el = selection[index];
          if (el.groupId === 'io.vertx' && el.artifactId === ('vertx-lang-' + oldLang.id)) {
            selection.splice(index--, 1);
          }
        }
      }
      // add the default language dependency
      opts.components.forEach(function (el, index) {
        if (el.groupId === 'io.vertx' && el.artifactId === ('vertx-lang-' + newLang.id)) {
          if (selection.filter(function (el2) { return el2.id === index; }).length === 0) {
            var c = clone(el);
            c.checked = true;
            c.id = index;
            selection.push(c);
          }
        }
      });

      var filteredPresets = filterPresets(self.tool.id, e.target.value);
      var filteredPresetsGroups = {};
      filteredPresets.forEach(function (el) {
        if (!filteredPresetsGroups[el.group]) {
          filteredPresetsGroups[el.group] = [];
        }
        filteredPresetsGroups[el.group].push(el);
      });

      self.update({
        // state change, disable old download
        downloading: false,
        presets: filteredPresets,
        presetGroups: filteredPresetsGroups,
        preset: filteredPresets.indexOf(self.preset) === -1 ? null : self.preset,
        language: newLang,
        dependencies: selection
      });
    }.bind(this);

    this.changePreset = function (e) {
      // carry on with the task...
      e.preventDefault();
      var oldPreset = self.preset;
      // virtual empty preset
      var newPreset = { dependencies : [
        "io.vertx:vertx-core"
      ]};

      if (e.target.value) {
        newPreset = self.presets.filter(function (el) {
          return el.id === e.target.value;
        })[0];

        ga('send', {
          hitType: 'event',
          eventCategory: newPreset.id + ':view',
          eventAction: newPreset.id + '/view',
          eventLabel: 'project'
        });
      }

      // reset
      var selection = [].concat(self.dependencies);
      if (oldPreset) {
        for (var index = 0; index < selection.length; index++) {
          var el = selection[index];
          // test with classifier
          if (oldPreset.dependencies.indexOf(el.groupId + ':' + el.artifactId + (el.classifier ? ':' + el.classifier : '')) !== -1) {
            selection.splice(index--, 1);
            continue;
          }
          // test without classifier
          if (oldPreset.dependencies.indexOf(el.groupId + ':' + el.artifactId) !== -1) {
            selection.splice(index--, 1);
            continue;
          }
        }
      }

      // check the default language dependency
      opts.components.forEach(function (el, index) {
        var c;
        if (newPreset.dependencies.indexOf(el.groupId + ':' + el.artifactId + (el.classifier ? ':' + el.classifier : '')) !== -1) {
          if (selection.filter(function (el2) { return el2.id === index; }).length === 0) {
            c = clone(el);
            c.checked = true;
            c.id = index;
            selection.push(c);
            return;
          }
        }
        if (newPreset.dependencies.indexOf(el.groupId + ':' + el.artifactId) !== -1) {
          if (selection.filter(function (el2) { return el2.id === index; }).length === 0) {
            c = clone(el);
            c.checked = true;
            c.id = index;
            selection.push(c);
            return;
          }
        }
      });

      self.update({
        // state change, disable old download
        downloading: false,
        preset: newPreset,
        dependencies: selection
      });
    }.bind(this);

    this.toggleDependency = function (e) {
      // carry on with the task...
      self.dependencies[e.target.value].checked = !self.dependencies[e.target.value].checked;

      self.update({
        // state change, disable old download
        downloading: false,
        dependencies: self.dependencies
      });
    }.bind(this);

    this.generate = function (e) {
      e.preventDefault();

      // animate to avoid the perception of slowness
      window.scroll(0, findPos(document.getElementById("interaction")));

      var submit = e.target.submit;
      var a = self.refs.download;

      submit.disabled = true;

      self.tool.fields.forEach(function (el) {
        el.value = e.target[el.key].value;
      });

      if (self.preset && self.preset.fields) {
        self.preset.fields.forEach(function (el) {
          el.value = e.target[el.key].value;
        });
      }

      // we need to filter in case the user was looking for other dependencies
      var dependencies = self.dependencies.filter(function (el) {
        return el.checked;
      });

      compileProject({buildtool: self.tool, dependencies: dependencies, language: self.language, preset: self.preset, components: opts.components}, function (err, zip) {
        if (err) {
          submit.disabled = false;
          self.update({
            generating: false
          });
          return alert(err);
        }

        if (JSZip.support.blob) {
          zip.generateAsync({ type: 'blob', platform: 'UNIX' }).then(function (blob) {
            if (a.href !== '#') {
              (window.webkitURL || window.URL).revokeObjectURL(a.href);
            }
            a.href = (window.webkitURL || window.URL).createObjectURL(blob);

            submit.disabled = false;
            self.update({
              generating: false,
              downloading: true
            });
            // at this moment the button should be visible
            try {
              document.getElementById('download-btn').focus();
              // attempt to click, will fail on safari and IE
              document.getElementById('download-btn').click();
            } catch (e) {
              // never mind...
            }
          }, function (err) {
            ga('send', 'exception', {
              'exDescription': err.message,
              'exFatal': true
            });
            alert(err);
          });
        } else {
          // blob is not supported on this browser fall back to data uri...
          zip.generateAsync({ type: 'base64', platform: 'UNIX' }).then(function (base64) {
            submit.disabled = false;
            self.update({
              generating: false,
              downloading: true
            });
            // start downloading...
            window.location = 'data:application/zip;base64,' + base64;
          }, function (err) {
            ga('send', 'exception', {
              'exDescription': err.message,
              'exFatal': true
            });
            alert(err);
          });
        }
      });

      self.update({
        generating: true,
        downloading: false,
        // the project name
        name: e.target.name.value
      });
    }.bind(this);

    this.clean = function (e) {
      // disable the link after click
      setTimeout(function () {
        self.downloading = false;
        self.update();
      }, 500);
    }.bind(this);

    this.search = function (e) {
      // create a filter index
      var found = [].concat(self.dependencies.filter(function (el) {
        return el.checked;
      }));

      var needle = e.target.value;
      var cnt = 0;
      if (needle.length > 0) {
        opts.components.forEach(function (el, index) {
          if (el.artifactId.indexOf(needle) !== -1 || (el.description && el.description.indexOf(needle) !== -1)) {
            var c = clone(el);
            c.checked = false;
            c.id = index;
            found.push(c);
            cnt++;
          }
        });

        if (cnt === 0) {
          // track misses so we can improve metadata
          ga('send', {
            hitType: 'event',
            eventCategory: 'search:fail',
            eventAction: needle + '/fail',
            eventLabel: 'component'
          });
        }
      }

      self.update({
        notfound: needle.length > 0 && cnt === 0,
        dependencies : found
      });
    }.bind(this);
  </script>
</main>
