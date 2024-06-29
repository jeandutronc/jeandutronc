import threading

# Define a custom exception for timeout
class TimeoutException(Exception):
    pass

# Function to run with a timeout
def run_with_timeout(func, args=(), kwargs={}, timeout=10):
    result = [None]  # To store the result or exception from the thread

    def target():
        try:
            print("Starting execution of", func.__name__)
            result[0] = func(*args, **kwargs)
        except Exception as e:
            result[0] = e

    thread = threading.Thread(target=target)
    thread.start()
    thread.join(timeout)  # Wait for the thread to complete or timeout

    if thread.is_alive():
        # If thread is still alive, it means it timed out
        raise TimeoutException(f"Timeout occurred after {timeout} seconds")
    else:
        # Thread has completed within the timeout
        if isinstance(result[0], Exception):
            # If result contains an exception, raise it
            raise result[0]
        else:
            return result[0]  # Return the result from the function

# Example usage
def long_running_function():
    import time
    time.sleep(5)  # Simulate a long running operation
    return "Task completed"

try:
    result = run_with_timeout(long_running_function, timeout=3)
    print("Function returned:", result)
except TimeoutException as e:
    print("Timeout occurred:", e)
except Exception as e:
    print("Exception occurred during function execution:", e)
