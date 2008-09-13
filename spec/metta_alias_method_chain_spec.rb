require File.dirname(__FILE__) + '/spec_helper'
require 'active_support'
require 'metta_alias_method_chain'

describe "alias_method_chain is already defined" do
  before(:each) do
    @klass = Class.new do
      def foo
        :foo
      end
    end
  end

  it "should not change anything if no new alias is defined" do
    @klass.alias_method_chain :foo, :jitsu
    @klass.new.foo.should == :foo
  end
  
  it "should work with prior alias_method_chain behavior" do
    @klass.class_eval do
      def foo_with_jitsu
        :bar
      end
      
      alias_method_chain :foo, :jitsu
    end
    
    @klass.new.foo.should == :bar
  end
  
  it "should define the 'without' alias chain method" do
    @klass.class_eval do
      def foo_with_jitsu
        [foo_without_jitsu, :bar]
      end
      alias_method_chain :foo, :jitsu
    end
    
    @klass.new.foo.should == [:foo, :bar]
  end
  
  it "should allow alias_method_chain call before aliased method definition" do
    @klass.class_eval do
      alias_method_chain :foo, :jitsu
      def foo_with_jitsu
        [foo_without_jitsu, :bar]
      end
    end
    
    @klass.new.foo.should == [:foo, :bar]
  end

  after(:all) do
    Module.send :undef_method, :alias_method_chain
  end
end
