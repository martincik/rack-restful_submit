lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rack'
require 'rack-restful_submit'

describe Rack::RestfulSubmit do
  let(:in_env) { {} }
  let(:out_env) { subject.call(in_env) }
  let(:app) {lambda {|env| env}}
  subject { Rack::RestfulSubmit.new(app) }

  describe "a get request" do
    it { app.should_receive(:call).with(in_env); out_env }
    it { out_env.should == in_env }
  end

  describe "a post request" do
    before do
      in_env['REQUEST_METHOD'] = 'POST'
      in_env['rack.input'] = in_env['form_input'] = ''
      in_env['rack.request.form_input'] = ''
      in_env["rack.request.form_hash"] = {}
    end

    Rack::RestfulSubmit::HTTP_METHODS.each do |method|
      describe "with #{method} and valid mapping" do
        before do
          in_env["rack.request.form_hash"] = {
            "__rewrite" => { method => "value is not important" },
            "__map" => {
              method => {
                "method" => method,
                "url" => "http://localhost:3000/#{method}"
              }
            }
          }
        end

        it { out_env['REQUEST_METHOD'].should == method }
        it { out_env['REQUEST_URI'].should == "http://localhost:3000/#{method}" }
      end

      describe "with #{method} and invalid mapping" do
        before do
          in_env['REQUEST_URI'] = "http://localhost:3000/"
          in_env["rack.request.form_hash"] = {
            "__rewrite" => { method => "value is not important" }
          }
        end

        it { out_env['REQUEST_METHOD'].should == "POST" }
        it { out_env['REQUEST_URI'].should == "http://localhost:3000/" }
      end
    end

    describe "with invalid method" do
      before do
        in_env['REQUEST_URI'] = "http://localhost:3000/"
        in_env["rack.request.form_hash"] = {
          "__rewrite" => { "ROCKSTARS" => "value is not important" }
        }
      end

      it { out_env['REQUEST_METHOD'].should == "POST" }
      it { out_env['REQUEST_URI'].should == "http://localhost:3000/" }
    end

    describe "with methodoverride support" do
      Rack::RestfulSubmit::HTTP_METHODS.each do |method|
        describe "with #{method} no __rewrite args" do
          before do
            in_env["rack.request.form_hash"] = { "_method" => method }
          end

          it { out_env['REQUEST_METHOD'].should == method }
        end

        describe "with #{method} and valid __rewrite args" do
          before do
            in_env["rack.request.form_hash"] = {
              "_method" => 'put',
              "__rewrite" => { method => "value is not important" },
              "__map" => {
                method => {
                  "method" => method,
                  "url" => "http://localhost:3000/#{method}"
                }
              }
            }
          end

          it { out_env['REQUEST_METHOD'].should == method }
        end

        describe "with #{method} and not valid __rewrite args" do
          before do
            in_env["rack.request.form_hash"] = {
              "_method" => method,
              "__rewrite" => { method => "value is not important" },
              "__map" => {}
            }
          end

          it { out_env['REQUEST_METHOD'].should == method }
        end
      end
    end

  end

end
