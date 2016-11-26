#!/usr/bin/env python

from pandocfilters import toJSONFilters, Str, Link, Header

def headinglinks(k, v, fmt, meta):
    if k == "Header":
        #[level, attrs, contents] = v
        #return Header(level, attrs, [ Link([], contents, [attrs[0]]) ])
        return Header()

if __name__=="__main__":
    toJSONFilters(headinglinks)


