node default {
    create_resources(
        'file',
        lookup(mopensuse::user::config::files::files),
        {'ensure'  => 'present'}
    )
}
