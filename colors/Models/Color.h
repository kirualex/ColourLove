//
//  Color.h
//  colors
//
// Copyright 2013 Alexis Creuzot
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@interface Color : ActiveRecord
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * userName;
@property (strong,nonatomic) NSString * hexString;

- (id) initWithDict:(NSDictionary *) dict;

- (UIColor *)rgbColor;
- (UIColor *)inversedColor;
- (UIColor *)contrastColor;
@end