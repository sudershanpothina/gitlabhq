class @AdminEmailSelect
  constructor: ->
    $('.ajax-admin-email-select').each (i, select) =>
      skip_ldap = $(select).hasClass('skip_ldap')

      $(select).select2
        placeholder: "Select group or project"
        multiple: $(select).hasClass('multiselect')
        minimumInputLength: 0
        query: (query) ->
          group_result = Api.groups query.term, skip_ldap, (groups) ->
            groups

          project_result = Api.projects query.term, (projects) ->
            projects

          $.when(project_result, group_result).done (projects, groups) ->
            data = $.merge(groups[0], projects[0])
            query.callback({ results: data})

        formatResult: (args...) =>
          @formatResult(args...)
        formatSelection: (args...) =>
          @formatSelection(args...)
        dropdownCssClass: "ajax-admin-email-dropdown"
        escapeMarkup: (m) -> # we do not want to escape markup since we are displaying html in results
          m

  formatResult: (object) ->
    if object.path_with_namespace
      "<div class='project-result'>
         <div class='project-name'>#{object.name}</div>
         <div class='project-path'>#{object.path_with_namespace}</div>
       </div>"
    else
      "<div class='group-result'>
         <div class='group-name'>#{object.name}</div>
         <div class='group-path'>#{object.path}</div>
       </div>"

  formatSelection: (object) ->
    if object.path_with_namespace
      "Project: #{object.name}"
    else
      "Group: #{object.name}"

