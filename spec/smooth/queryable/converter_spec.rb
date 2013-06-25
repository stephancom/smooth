require "spec_helper"

class MyCollection
  include Smooth::Queryable
end

describe Smooth::Queryable do

  describe "Equality" do
    it "should handle equality" do
      results = MyCollection.query({title:"Test"});
    end

    it "should handle equality" do
      results = MyCollection.query({ title: {"$equal"=>"Test"} });
    end
  end

  # MyCollection.query({ colors: {$contains: "red"} });
  xit "should support $contains" do
  end

  xit "should support $ne" do
    MyCollection.query({ title: {"$ne"=>"Test"} })
  end

  xit "should support $lt" do
    MyCollection.query({ likes: {"$lt"=>10} })
  end

  xit "should support $lte" do
    MyCollection.query({ likes: {"$lte"=>10} })
  end

  xit "should support $gt" do
    MyCollection.query({ likes: {"$gt"=>10} })
  end

  xit "should support $gte" do
    MyCollection.query({ likes: {"$gte"=>10} })
  end

  xit "should support $between" do
    MyCollection.query({ likes: {"$between"=>[5,15] } })
  end

  xit "should support $in" do
    MyCollection.query({ title: {"$in"=>["About", "Home", "Contact"] } });
  end

  xit "should support $nin" do
    MyCollection.query({ title: { "$nin"=>["About", "Home", "Contact"] } });
  end

  xit "should support $all" do
  end

  xit "should support $any" do
  end

  xit "should support $size" do
  end

  xit "should support $exists" do
  end

  xit "should support $has" do
  end

  xit "should support $like" do
    MyCollection.query({ title: {"$like"=> "Test"} });
  end

  xit "should support $likeI" do
    MyCollection.query({ title: {"$likeI"=> "Test" } });
  end

  xit "should support $regex" do
    MyCollection.query({ content: {"$regex"=> /coffeescript/i } });
  end

  xit "should support $regex" do
    MyCollection.query({ content: /coffeescript/i });
  end

  describe "Combined Queries" do
    xit "should support $and" do
      MyCollection.query({ "$and"=> { title: {"$like"=> "News"}, likes: {"$gt"=> 10}}});
      MyCollection.query({ title: {"$like"=> "News"}, likes: {"$gt"=> 10} });
    end

    xit "should support $or" do
      MyCollection.query({ "$or"=> { title: { "$like"=> "News"}, likes: { "$gt"=> 10}}});
    end

    xit "should support $nor" do
      MyCollection.query({"$nor"=> { title: {"$like"=> "News"}, likes: {"$gt"=> 10}}});
    end

    xit "should support $not" do
      MyCollection.query({"$not"=> { title: { "$like"=> "News"}, likes: { "$gt"=> 10}}});
    end
  end
end
