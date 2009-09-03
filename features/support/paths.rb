module NavigationHelpers
  # Maps a static name to a static route.
  #
  # This method is *not* designed to map from a dynamic name to a
  # dynamic route like <tt>post_comments_path(post)</tt>. For dynamic
  # routes like this you should *not* rely on #path_to, but write
  # your own step definitions instead. Example:
  #
  #   Given /I am on the comments page for the "(.+)" post/ |name|
  #     post = Post.find_by_name(name)
  #     visit post_comments_path(post)
  #   end
  #
  def path_to(page_name)
    case page_name

    when /the homepage/
      root_path

    when /the tasks page/
      tasks_path

    when /the new child page/
      new_child_path

    when /the onsite children page/
      onsite_children_path

    when /the boarding offsite children page/
      boarding_offsite_children_path

    when /the dropped out children page/
      dropped_out_children_path

    when /the reunified children page/
      reunified_children_path

    when /the terminated children page/
      terminated_children_path

    when /the new caregiver page/
      new_caregiver_path

    # I'm including these "dynamic" paths here despite the warning above
    # because cucumber complains about ambiguous steps when I make a separate
    # "When I go to ..." step.
    #
    # You can fix this by adding --guess to the command-line options, but
    # there's nowhere to do that when you're running a single feature in
    # TextMate except for the TM_CUCUMBER_OPTS environment variable.
    #
    # I wouldn't generally want to mess with TM_CUCUMBER_OPTS, because (1) I
    # might want ambiguity warnings for other projects, and (2) other
    # developers would have to know to do the same thing.
    #
    # Or, perhaps I could set the variable in a .tmproj file?
    when /the child page for "(.+)"/
      child_path(Child.find_by_name!($1))

    when /the caregiver page for "(.+)"/
      caregiver_path(Caregiver.find_by_name!($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
end

World(NavigationHelpers)
