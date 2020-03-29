class Observer 
    def initialize()
        @observers = []
    end

    # Add an observer that is associated with the profile following functionality
    def add_observer(observer)
        @observers << observer
    end

    # Delete an observer that is associated with the profile following functionality
    def delete_observer(observer)
        @observers.delete(observer)
    end

    def notify_observers(follower_id, followee_id)
        @observers.each do |observer|
            observer.update(follower_id, followee_id)
        end
    end
end

# Making the Listener the child class for Observer
class Listener < Observer
    def initialize
        super()
    end

    # This method notifies the observers that there is a new profile following
    def trigger_following(follower_id, followee_id)
        notify_observers(follower_id, followee_id)
    end
end