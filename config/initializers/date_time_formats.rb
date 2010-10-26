DateTime::DATE_FORMATS[:html5] =
  Time::DATE_FORMATS[:html5] = lambda { |date|
  date.strftime('%Y-%m-%dT%H:%M:%S%z').
    sub('+0000', '-0000').insert(-3, ':')
}

