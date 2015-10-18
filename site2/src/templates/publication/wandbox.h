#ifndef PUBLICATION_WANDBOX_H_INCLUDED
#define PUBLICATION_WANDBOX_H_INCLUDED

#include <string>
#include <functional>
#include <tuple>
#include "googleio.h"

namespace content {
namespace publication {
    struct wandbox : public googleio {
        static index_t internal_json() {
            static const char* internal_json_str = R"raw(
              { "title": "目次"
              , "contents":
                [ { "name": "relation"
                  , "title": "牛舎と犬小屋の関係"
                  }
                , { "name": "cattleshed"
                  , "title": "牛舎"
                  }
                , { "name": "kennel"
                  , "title": "犬小屋"
                  , "contents":
                    [ { "name": "yesod"
                      , "title": "Yesod"
                      }
                    , { "name": "templates"
                      , "title": "Templates"
                      }
                    , { "name": "eventsource"
                      , "title": "EventSource"
                      }
                    ]
                  }
                , { "name": "kurou"
                  , "title": "苦労話"
                  }
                ]
              }
            )raw";
            std::stringstream ss(internal_json_str);
            index_t json;
            json.load(ss, true, nullptr);
            return json;
        }
        std::string internal(index_func_t func, const char* str) {
            static index_t json = internal_json();
            return func(json, str);
        }

        static index_t server_json() {
            static const char* server_json_str = R"raw(
              { "title": "目次"
              , "contents":
                [ { "name": "all"
                  , "title": "全体構成"
                  , "contents":
                    [ { "name": "mighttpd"
                      , "title": "Mighttpd"
                      }
                    ]
                  }
                , { "name": "management"
                  , "title": "サーバ管理"
                  , "contents":
                    [ { "name": "chef"
                      , "title": "Chef"
                      }
                    , { "name": "deploy"
                      , "title": "Deploy"
                      }
                    ]
                  }
                ]
              }
            )raw";
            std::stringstream ss(server_json_str);
            index_t json;
            json.load(ss, true, nullptr);
            return json;
        }
        std::string server(index_func_t func, const char* str) {
            static index_t json = server_json();
            return func(json, str);
        }

        const char* source_hamlet_sample1() {
return R"raw(
<div .span2 #editor-settings>
  <label .row-fluid>choose key binding:
  <select .span12 size=3>
    <option value="ace" selected>default
    <option value="vim">Vim
    <option value="emacs">Emacs
  <label .checkbox>
    <input type="checkbox" value="use-legacy-editor">Use Legacy Editor)raw";
        }

        const char* source_hamlet_sample1_html() {
return R"raw(
<div class="span2" id="editor-settings">
  <label class="row-fluid">choose key binding:</label>
  <select class="span12" size=3>
    <option value="ace" selected>default</option>
    <option value="vim">Vim</option>
    <option value="emacs">Emacs</option>
  </select>
  <label class="checkbox">
    <input type="checkbox" value="use-legacy-editor">Use Legacy Editor</input>
  </label>
</div>)raw";
        }

        const char* source_hamlet_sample2() {
return R"raw(
<div .row-fluid>
  <div #compile-options>
    $forall info <- compilerInfos
      <div compiler="#{verName $ ciVersion info}">
        $forall sw <- ciSwitches info
          ^{makeSwitch (verName (ciVersion info)) sw})raw";
        }

        const char* source_lucius_sample() {
return R"raw(
@textcolor: #ccc;
body {
  color: #{textcolor};
  a {
    color: #{textcolor};
  }
})raw";
        }

        const char* source_lucius_sample_css() {
return R"raw(
body {
  color: #ccc;
}
body a {
  color: #ccc;
})raw";
        }

        const char* source_julius_sample() {
return R"raw(
$(function() {
  var result_container = new ResultContainer('#result-container')
  result_container.onfinish = function() {
    $('#compile').show();
    $('#compiling').hide();
  };
  ...
  var compiler = new Compiler('#compiler', '#compile-options');
  compiler.set_compiler(#{defaultCompiler});
});)raw";
        }

        const char* source_loop_sample() {
return R"raw(
main = mapM_ print [1..])raw";
        }
    };
}}

#endif // PUBLICATION_WANDBOX_H_INCLUDED
