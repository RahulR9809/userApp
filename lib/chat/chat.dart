
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/chat/bloc/chat_bloc.dart';
// class Message {
//   final String text;
//   final bool isSender;

//   Message({required this.text, required this.isSender});
// }

// class ChatPage extends StatefulWidget {
//   const ChatPage({Key? key}) : super(key: key);

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
// ChatBloc _chatBloc=ChatBloc();
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _chatBloc = BlocProvider.of<ChatBloc>(context);
//     _initializeChat();
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _initializeChat() async {

//     _chatBloc.add(LoadMessages());
//   }

 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<ChatBloc, ChatState>(
//         builder: (context, state) {
//           if (state is ChatLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state is ChatMessagesLoaded) {
//             return _buildChatList(state.messages);
//           }
//           if (state is ChatError) {
//             return Center(
//               child: Text(
//                 state.message,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }
//           return const Center(child: Text('No messages yet.'));
//         },
//       ),
//     );
//   }

//   Widget _buildChatList(List<String> messages) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });

//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             controller: _scrollController,
//             itemCount: messages.length,
//             itemBuilder: (context, index) {
//               return _buildChatBubble(
//                 message: messages[index],
//                 isSender: index.isEven,
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _messageController,
//                   decoration: const InputDecoration(
//                     hintText: 'Type a message...',
//                     border: OutlineInputBorder(),
//                     filled: true,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: () {
//                   final message = _messageController.text.trim();
//                   if (message.isNotEmpty) {
//                     _chatBloc.add(SendMessage(message: message));
//                     _messageController.clear();
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       if (_scrollController.hasClients) {
//                         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//                       }
//                     });
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Message cannot be empty'),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChatBubble({required String message, required bool isSender}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//       child: Row(
//         mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: isSender ? Colors.deepPurpleAccent : Colors.grey[300],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Text(
//               message,
//               style: TextStyle(
//                 color: isSender ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/chat/bloc/chat_bloc.dart';
import 'package:rideuser/controller/chat_usersoketcontroller.dart'; // Import the socket service

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatBloc _chatBloc;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final UserChatSocketService _socketService = UserChatSocketService(); // Instance of the socket service

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    _chatBloc.add(LoadMessages());
  
    _socketService.setOnMessageReceivedCallback((data) {
      final String message = data['message'] ?? '';
      _chatBloc.add(MessageReceived( message)); // Dispatch the message to the Bloc
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChatMessagesLoaded) {
            return _buildChatList(state.messages);
          }
          if (state is ChatError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text('No messages yet.'));
        },
      ),
    );
  }

Widget _buildChatList(List<Map<String, dynamic>> messages) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  });

  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildChatBubble(
              message: messages[index]['message'],
              isSender: messages[index]['isSender'],
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final message = _messageController.text.trim();
                if (message.isNotEmpty) {
                  _chatBloc.add(SendMessage(message: message));
                  _messageController.clear();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message cannot be empty')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildChatBubble({required String message, required bool isSender}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    child: Row(
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSender ? Colors.deepPurpleAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isSender ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
}