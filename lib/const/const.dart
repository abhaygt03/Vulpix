import 'package:flutter/material.dart';      

Radius msgradius=Radius.circular(10);

BorderRadiusGeometry senderBubble= BorderRadius.only(
                                    topLeft: msgradius,
                                    topRight: msgradius,
                                    bottomLeft: msgradius,
                                          );

 BorderRadiusGeometry receiverBubble=BorderRadius.only(
                                      bottomRight: msgradius,
                                      topRight: msgradius,
                                      bottomLeft: msgradius,
                                    );