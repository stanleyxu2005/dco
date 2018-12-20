# Delphi Communication Object #

"dco" is an Inter-Process-Communication framework, which provides the ability to
exchange data between multiple processes using different transport techniques
(currently Windows messaging and named pipe). It aims to reach a high data
throughput. It uses JSON-RPC 2.0 for serialization.

IMPORTANT: Considering about using the exciting new Delphi language features 
(such as for-in-loop, generic types, advances record type, class constructor, 
Unicode support), the code might not be compatible with old Delphi compilers. 
We recommend you use Embarcadero RAD Studio XE2 or higher.

We hope you enjoy using the library, although the usage is poorly documented. 
We would be very appreciated, if you can help us to make it better.

## Getting Started ##

The project requires diverse 3rd-party open source runtime libraries.

1. Goto the directory 'include' and download these open source libraries. 
   a. These libraries does not have any license issues. 
   b. If you do not want to use these libraries, you can simply remove related 
      units and unittests.
2. Add these source paths to the browsing path of Delphi IDE. 

As soon as you installed all prerequisites, we should build the project. 

1. Open the project group file at the directory 'make' and execute "Build All". 
2. Run the unittests from project manager.
3. Add the source paths to the browsing path of Delphi IDE. 

Now the dco is ready to use. Please check the demo project and have fun.

## Notes ##

As I recently noticed that the Apache Thift has Delphi support, I'd use some of
my spare time to evaluate performance and code quality of Apache Thift. 

Welcome you to create tickets on github or mail me for feature requests.