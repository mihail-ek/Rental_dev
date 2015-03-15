$ ->
  $("input#search-field").typeahead [
    name: "projects"
    remote: "../api/v1/projects/search.json?query=%QUERY"
    header: "<h3>Projects</h3>"
    valueKey: 'name'
    template: ["<p>{{name}}</p>"].join("")
    engine: Hogan
  ,
    name: "charities"
    remote: "../api/v1/charities/search.json?query=%QUERY"
    header: "<h3>Charities</h3>"
    valueKey: 'name'
    template: ["<p>{{name}}</p>"].join("")
    engine: Hogan
  ,
    name: "users"
    remote: "../api/v1/users/search.json?query=%QUERY"
    header: "<h3>Users</h3>"
    valueKey: 'name'
    template: ["<p>{{name}}</p>"].join("")
    engine: Hogan
  ]

  $("input#search-field").on "typeahead:selected", (event, object) ->
    window.location.href = "#{object['path']}"

  $('body').on "change keyup", (event) ->
    if event.keyCode == 191 # slash
      $('input#search-field').focus()
