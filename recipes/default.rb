#
# Cookbook Name:: locale
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

lang = node[:locale][:lang]

if platform?("ubuntu", "debian")

  # upcase charset
  lang = lang.gsub(/\..+$/) { |c| c.upcase }
  # insert dashes
  lang = lang.gsub(/\.UTF(\d+)/, '.UTF-\1')

  package "locales" do
    action :install
  end

  execute "Generate locale" do
    command "locale-gen #{lang}"
    not_if "locale -a | grep -qx #{lang}"
  end

  execute "Update locale" do
    command "update-locale LANG=#{lang}"
    not_if "cat /etc/default/locale | grep -qx LANG=#{lang}"
  end

end

if platform?("redhat", "centos", "fedora")
  # downcase charset
  lang = lang.gsub(/\..+$/) { |c| c.downcase }
  # remove dashes
  lang = lang.gsub(/\.utf-(\d+)/, '.utf\1')

  execute "Update locale" do
    command "locale -a | grep -qx #{lang} && sed -i 's|LANG=.*|LANG=#{lang}|' /etc/sysconfig/i18n"
    not_if "grep -qx LANG=#{lang} /etc/sysconfig/i18n"
  end

end

