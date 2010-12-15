Rack RESTful Submit
===================

Implements support of RESTful resources with Rails MVC when Javascript is off and bulk operations are required with multiple submit buttons.

Rack Builder
------------

    require 'rack-restful_submit'
    use Rack::RestfulSubmit

Rails integration
-----------------

### Install GEM without Bundler

Insert into config/environment.rb:

    config.gem "rack-restful_submit"

Run:

    rake gems:install

### Install GEM with Bundler

Insert into Gemfile:

    gem "rack-restful_submit"

Run:

    bundle install

### Integration

We need to swap our RestfulSubmit middleware with MethodOverride which we don't need anymore.

Insert into config/environment.rb:


    config.middleware.swap Rack::MethodOverride, 'Rack::RestfulSubmit'


Usage
-----

In the example below you can see that using submit input with `__rewrite` name and `multi_destroy` mapping allows
us to convert normal POST request into RESTful one. Don't forget to also insert 2 hidden fields URL and METHOD as shown below.
__NOTE:__ I'm aware of that adding collection to RESTfull controller ins't very RESTfull but this is only example of this GEM. If you want fully RESTfull create new controller for the bulk operations.

Example of industries/index.html.erb

    <h1>Listing industries</h1>

    <form method="post">
    <table>
      <tr>
        <th>Name</th>
        <th>Description</th>
      </tr>

    <% @industries.each do |industry| %>
      <tr>
        <td><%=h check_box_tag 'industry_ids[]', industry.id %></td>
        <td><%=h link_to industry.name, industry %></td>
        <td><%=h industry.description %></td>
        <td><%= link_to 'Edit', edit_industry_path(industry) %></td>
      </tr>
    <% end %>
    </table>

    <input type="hidden" name="__map[multi_destroy][url]" value="<%= destroy_multiple_industries_url %>" />
    <input type="hidden" name="__map[multi_destroy][method]" value="DELETE" />
    <input type="submit" name="__rewrite[multi_destroy]" value="Destroy">

    </form>

    <br />

    <%= link_to 'New industry', new_industry_path %>

Routes:

    map.resources :industries, :collection => { :destroy_multiple => :delete }

Contribute
----------

The Github way: Fork Me, Hack Me, Push Me, Send Me as Pull Request

License
-------

(c) 2010 Ladislav Martincik - MIT License (see LICENSE)

History
-------

1.1.2 - Fixing bug with double Rack call()
1.1.1 - Define Gemfile and decrease RSpec version to 1.3.0
1.1.0 - Version with MethodOverride support inside
1.0.0 - First working version
