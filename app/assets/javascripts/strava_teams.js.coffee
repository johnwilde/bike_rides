# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# load the competition results table using DataTable and sort
# in descending order by total elevation (the second column)
jQuery ->
        $('#results').dataTable({
            "aaSorting": [[ 1, "desc" ]]}
        )
