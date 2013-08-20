//
//  main.m
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 19.08.13.
//  Copyright (c) 2013 CIMenu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
