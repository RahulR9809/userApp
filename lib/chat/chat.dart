// import 'package:flutter/material.dart';



// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController(); // For auto-scrolling
//   List<String> messages = []; // List of chat messages

//   @override
//   void dispose() {
//     // driverSocketChatService.disconnect();
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _sendMessage() {
//     final message = _messageController.text.trim();
//     if (message.isNotEmpty) {
//       setState(() {
//         messages.add("You: $message");
//         _messageController.clear();
//       });
//       // Scroll to bottom
//       Future.delayed(Duration(milliseconds: 100), () {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Container(),
//         title: const Text(
//           'Driver Chat',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.deepPurple, // Unique theme color
//         centerTitle: true,
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(20),
//             bottomRight: Radius.circular(20),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('asset/chat.png'), // Add your image asset here
//             fit: BoxFit.contain,
//           ),
//         ),
//         child: Column(
//           children: [
//             // Chat Messages List
//             Expanded(
//               child: ListView.builder(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.all(10),
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   bool isUserMessage = messages[index].startsWith('You:');
//                   return Align(
//                     alignment: isUserMessage
//                         ? Alignment.centerRight
//                         : Alignment.centerLeft,
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 6, horizontal: 12),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 16),
//                       decoration: BoxDecoration(
//                         gradient: isUserMessage
//                             ? LinearGradient(
//                                 colors: [Colors.deepPurple, Colors.deepPurple.shade300],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               )
//                             : LinearGradient(
//                                 colors: [Colors.grey.shade200, Colors.grey.shade300],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20),
//                           bottomLeft: isUserMessage
//                               ? Radius.circular(20)
//                               : Radius.zero,
//                           bottomRight: isUserMessage
//                               ? Radius.zero
//                               : Radius.circular(20),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 6,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         messages[index].replaceFirst('You: ', ''),
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: isUserMessage ? Colors.white : Colors.black87,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Message Input Field
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       style: const TextStyle(fontSize: 16),
//                       decoration: InputDecoration(
//                         hintText: 'Write your message here...',
//                         hintStyle: const TextStyle(color: Colors.grey),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 16),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: _sendMessage,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [Colors.deepPurple, Colors.deepPurpleAccent],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withOpacity(0.5),
//                             blurRadius: 8,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: const Padding(
//                         padding: EdgeInsets.all(12),
//                         child: Icon(
//                           Icons.send,
//                           color: Colors.white,
//                           size: 26,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/chat/bloc/chat_bloc.dart';

// class ChatPage extends StatefulWidget {

//   const ChatPage({Key? key,}) : super(key: key);

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   late ChatBloc _chatBloc;
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _chatBloc = BlocProvider.of<ChatBloc>(context);
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
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount:1, // Replace with dynamic messages count
//                   itemBuilder: (context, index) => Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.deepPurpleAccent,
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Text(
//                             _messageController.text,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _messageController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(),
//                           filled: true,
                          
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       onPressed: () {
//                         final message = _messageController.text.trim();
//                         if (message.isNotEmpty) {
//                           _chatBloc.add(SendMessage(
//                             message: message,
//                           ));
//                           _messageController.clear();
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               if (state is ChatMessageSent)
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     'Message Sent',
//                     style: TextStyle(color: Colors.green),
//                   ),
//                 ),
//               if (state is ChatMessageReceived)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Received: ${state.message}',
//                     style: const TextStyle(color: Colors.blue),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/chat/bloc/chat_bloc.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatBloc _chatBloc;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
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
          List<String> messages = [];
          if (state is ChatMessagesLoaded) {
            messages = state.messages;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            messages[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          _chatBloc.add(SendMessage(
                            message: message,
                          ));
                          _messageController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (state is ChatMessageSent)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Message Sent',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
