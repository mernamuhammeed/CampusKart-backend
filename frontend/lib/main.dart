import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:golfcar/api_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

// Exact station names provided by backend team
const List<String> kStationNames = [
  'Admission Station',
  'Engineering Station',
  'Arts & Design Station',
  'CS & Eng Station',
  'Pharmacy Station',
  'Nursing Station',
  'Medical Station',
  'Dentistry Station',
  'Physical Therapy Station',
  'Applied Health Station',
  'Science Station',
];

const Map<String, LatLng> kStationCoords = {
  'Admission Station': LatLng(29.43107812, 32.40167970),
  'Engineering Station': LatLng(29.43355847, 32.39782279),
  'Arts & Design Station': LatLng(29.43288092, 32.39706283),
  'CS & Eng Station': LatLng(29.43024508, 32.39937072),
  'Pharmacy Station': LatLng(29.42801924, 32.40190099),
  'Nursing Station': LatLng(29.42742306, 32.40280592),
  'Medical Station': LatLng(29.42654577, 32.40400374),
  'Dentistry Station': LatLng(29.42828960, 32.40561523),
  'Physical Therapy Station': LatLng(29.42928356, 32.40415616),
  'Applied Health Station': LatLng(29.42998180, 32.40316778),
  'Science Station': LatLng(29.43192535, 32.40053784),
};

const List<LatLng> kAllNodes = [
  LatLng(29.43118703, 32.40160259), // 0: Admission Station (Node 0)
  LatLng(29.43121880, 32.40155726), // 1: Admission Station (Node 1)
  LatLng(29.43124173, 32.40151417), // 2: Road Node 2
  LatLng(29.43129136, 32.40143157), // 3: Road Node 3
  LatLng(29.43133379, 32.40136337), // 4: Road Node 4
  LatLng(29.43137421, 32.40130343), // 5: Road Node 5
  LatLng(29.43140298, 32.40126546), // 6: Road Node 6
  LatLng(29.43143592, 32.40121975), // 7: Road Node 7
  LatLng(29.43146443, 32.40118051), // 8: Road Node 8
  LatLng(29.43157970, 32.40102833), // 9: Road Node 9
  LatLng(29.43167444, 32.40090357), // 10: Road Node 10
  LatLng(29.43181307, 32.40071941), // 11: Science Station (Node 11)
  LatLng(29.43190802, 32.40059569), // 12: Science Station (Node 12)
  LatLng(29.43204901, 32.40041603), // 13: Science Station (Node 13)
  LatLng(29.43217263, 32.40025371), // 14: Road Node 14
  LatLng(29.43233211, 32.40005220), // 15: Road Node 15
  LatLng(29.43246485, 32.39987910), // 16: Road Node 16
  LatLng(29.43256982, 32.39975405), // 17: Road Node 17
  LatLng(29.43265604, 32.39965054), // 18: Road Node 18
  LatLng(29.43273365, 32.39955402), // 19: Road Node 19
  LatLng(29.43281242, 32.39946382), // 20: Road Node 20
  LatLng(29.43291935, 32.39934708), // 21: Road Node 21
  LatLng(29.43304649, 32.39921275), // 22: Road Node 22
  LatLng(29.43315932, 32.39909256), // 23: Road Node 23
  LatLng(29.43327805, 32.39896504), // 24: Road Node 24
  LatLng(29.43340428, 32.39882546), // 25: Road Node 25
  LatLng(29.43356871, 32.39863110), // 26: Road Node 26
  LatLng(29.43368862, 32.39849360), // 27: Road Node 27
  LatLng(29.43377799, 32.39839435), // 28: Turn Corner1 Node 28
  LatLng(29.43380399, 32.39835794), // 29: Turn Corner1 Node 29
  LatLng(29.43382288, 32.39831704), // 30: Turn Corner1 Node 30
  LatLng(29.43383085, 32.39828813), // 31: Turn Corner1 Node 31
  LatLng(29.43383813, 32.39825120), // 32: Turn Corner1 Node 32
  LatLng(29.43383844, 32.39822562), // 33: Turn Corner1 Node 33
  LatLng(29.43383599, 32.39819344), // 34: Turn Corner1 Node 34
  LatLng(29.43382960, 32.39816697), // 35: Turn Corner1 Node 35
  LatLng(29.43382223, 32.39813936), // 36: Turn Corner1 Node 36
  LatLng(29.43381338, 32.39811125), // 37: Turn Corner1 Node 37
  LatLng(29.43379651, 32.39807497), // 38: Turn Corner1 Node 38
  LatLng(29.43377924, 32.39804805), // 39: Reg Bump 1
  LatLng(29.43375605, 32.39801852), // 40: Turn Corner1 Node 40
  LatLng(29.43373766, 32.39799869), // 41: Road Node 41
  LatLng(29.43372191, 32.39798169), // 42: Road Node 42
  LatLng(29.43370186, 32.39795936), // 43: Engineering Station (Node 43)
  LatLng(29.43361581, 32.39785773), // 44: Engineering Station (Node 44)
  LatLng(29.43353809, 32.39776640), // 45: Engineering Station (Node 45)
  LatLng(29.43346843, 32.39768216), // 46: Engineering Station (Node 46)
  LatLng(29.43339088, 32.39759405), // 47: Road Node 47
  LatLng(29.43330418, 32.39749848), // 48: Road Node 48
  LatLng(29.43322261, 32.39740778), // 49: Road Node 49
  LatLng(29.43312745, 32.39729800), // 50: Road Node 50
  LatLng(29.43303896, 32.39719780), // 51: Arts & Design Station (Node 51)
  LatLng(29.43298257, 32.39713847), // 52: Arts & Design Station (Node 52)
  LatLng(29.43291259, 32.39706212), // 53: Arts & Design Station (Node 53)
  LatLng(29.43286608, 32.39701248), // 54: Arts & Design Station (Node 54)
  LatLng(29.43280875, 32.39695322), // 55: Arts & Design Station (Node 55)
  LatLng(29.43276318, 32.39691352), // 56: Arts & Design Station (Node 56)
  LatLng(29.43272036, 32.39688042), // 57: Road Node 57
  LatLng(29.43267726, 32.39684841), // 58: Road Node 58
  LatLng(29.43263870, 32.39682203), // 59: Road Node 59
  LatLng(29.43259614, 32.39680216), // 60: Road Node 60
  LatLng(29.43255404, 32.39677990), // 61: Road Node 61
  LatLng(29.43251439, 32.39676346), // 62: Road Node 62
  LatLng(29.43247978, 32.39674902), // 63: Road Node 63
  LatLng(29.43243913, 32.39673316), // 64: Road Node 64
  LatLng(29.43241082, 32.39671672), // 65: Road Node 65
  LatLng(29.43239191, 32.39669955), // 66: Road Node 66
  LatLng(29.43237297, 32.39667911), // 67: Road Node 67
  LatLng(29.43235774, 32.39666061), // 68: Roundabout Node 68
  LatLng(29.43235756, 32.39663887), // 69: Roundabout Node 69
  LatLng(29.43235082, 32.39660905), // 70: Roundabout Node 70
  LatLng(29.43233840, 32.39657699), // 71: Roundabout Node 71
  LatLng(29.43231696, 32.39654130), // 72: Roundabout Node 72
  LatLng(29.43229826, 32.39651568), // 73: Roundabout Node 73
  LatLng(29.43228401, 32.39650030), // 74: Roundabout Node 74
  LatLng(29.43226491, 32.39648283), // 75: Roundabout Node 75
  LatLng(29.43222538, 32.39646745), // 76: Roundabout Node 76
  LatLng(29.43219810, 32.39646117), // 77: Roundabout Node 77
  LatLng(29.43217754, 32.39646123), // 78: Roundabout Node 78
  LatLng(29.43214904, 32.39646942), // 79: Roundabout Node 79
  LatLng(29.43212053, 32.39648393), // 80: Roundabout Node 80
  LatLng(29.43208955, 32.39650629), // 81: Roundabout Node 81
  LatLng(29.43205657, 32.39654461), // 82: Roundabout Node 82
  LatLng(29.43203435, 32.39659049), // 83: Roundabout Node 83
  LatLng(29.43202763, 32.39663243), // 84: Roundabout Node 84
  LatLng(29.43202970, 32.39666958), // 85: Roundabout Node 85
  LatLng(29.43203830, 32.39671066), // 86: Roundabout Node 86
  LatLng(29.43205306, 32.39674366), // 87: Roundabout Node 87
  LatLng(29.43206649, 32.39676634), // 88: Roundabout Node 88
  LatLng(29.43209119, 32.39679142), // 89: Roundabout Node 89
  LatLng(29.43212109, 32.39680484), // 90: Roundabout Node 90
  LatLng(29.43215722, 32.39681906), // 91: Roundabout Node 91
  LatLng(29.43218957, 32.39681762), // 92: Roundabout Node 92
  LatLng(29.43223211, 32.39680888), // 93: Roundabout Node 93
  LatLng(29.43226568, 32.39679396), // 94: Roundabout Node 94
  LatLng(29.43229605, 32.39677175), // 95: Roundabout Node 95
  LatLng(29.43233026, 32.39674294), // 96: Roundabout Node 96
  LatLng(29.43198191, 32.39672069), // 97: Road Node 97
  LatLng(29.43191618, 32.39679532), // 98: Road Node 98
  LatLng(29.43186027, 32.39686344), // 99: Reg Bump 21
  LatLng(29.43178889, 32.39694910), // 100: Road Node 100
  LatLng(29.43174071, 32.39700818), // 101: Road Node 101
  LatLng(29.43166892, 32.39709465), // 102: Road Node 102
  LatLng(29.43157939, 32.39720599), // 103: Road Node 103
  LatLng(29.43150595, 32.39729762), // 104: Road Node 104
  LatLng(29.43144089, 32.39737387), // 105: Spiked Bump 5
  LatLng(29.43137739, 32.39745251), // 106: Road Node 106
  LatLng(29.43130839, 32.39753529), // 107: Road Node 107
  LatLng(29.43123970, 32.39761097), // 108: Road Node 108
  LatLng(29.43113286, 32.39773667), // 109: Road Node 109
  LatLng(29.43099900, 32.39789322), // 110: Road Node 110
  LatLng(29.43085405, 32.39806438), // 111: Road Node 111
  LatLng(29.43071638, 32.39823113), // 112: Road Node 112
  LatLng(29.43063433, 32.39832273), // 113: Road Node 113
  LatLng(29.43055371, 32.39842077), // 114: Spiked Bump 3
  LatLng(29.43044497, 32.39854244), // 115: Road Node 115
  LatLng(29.43038765, 32.39861427), // 116: Reg Bump 19
  LatLng(29.43029148, 32.39871638), // 117: Road Node 117
  LatLng(29.43026035, 32.39872484), // 118: Roundabout Node 118
  LatLng(29.43023489, 32.39872414), // 119: Roundabout Node 119
  LatLng(29.43021136, 32.39872233), // 120: Road Node 120
  LatLng(29.43018204, 32.39871632), // 121: Roundabout Node 121
  LatLng(29.43013685, 32.39871973), // 122: Roundabout Node 122
  LatLng(29.43009147, 32.39873699), // 123: Roundabout Node 123
  LatLng(29.43006510, 32.39875734), // 124: Roundabout Node 124
  LatLng(29.43004047, 32.39878033), // 125: Roundabout Node 125
  LatLng(29.43002061, 32.39880839), // 126: Roundabout Node 126
  LatLng(29.42999908, 32.39884474), // 127: Roundabout Node 127
  LatLng(29.42998808, 32.39888795), // 128: Roundabout Node 128
  LatLng(29.42998699, 32.39893303), // 129: Roundabout Node 129
  LatLng(29.42998883, 32.39896286), // 130: Roundabout Node 130
  LatLng(29.42999703, 32.39899198), // 131: Roundabout Node 131
  LatLng(29.43001323, 32.39902303), // 132: Roundabout Node 132
  LatLng(29.43003122, 32.39904642), // 133: Roundabout Node 133
  LatLng(29.43004989, 32.39906513), // 134: Roundabout Node 134
  LatLng(29.43007061, 32.39908329), // 135: Roundabout Node 135
  LatLng(29.43009720, 32.39909917), // 136: Roundabout Node 136
  LatLng(29.43012257, 32.39910914), // 137: Roundabout Node 137
  LatLng(29.43014797, 32.39911353), // 138: Roundabout Node 138
  LatLng(29.43017339, 32.39911362), // 139: Roundabout Node 139
  LatLng(29.43020231, 32.39910801), // 140: Roundabout Node 140
  LatLng(29.43022473, 32.39910347), // 141: Roundabout Node 141
  LatLng(29.43025400, 32.39908628), // 142: Roundabout Node 142
  LatLng(29.43028330, 32.39906317), // 143: Roundabout Node 143
  LatLng(29.43030710, 32.39903027), // 144: Roundabout Node 144
  LatLng(29.43031865, 32.39899790), // 145: Roundabout Node 145
  LatLng(29.43032544, 32.39896611), // 146: Roundabout Node 146
  LatLng(29.43033321, 32.39892931), // 147: Roundabout Node 147
  LatLng(29.43033412, 32.39889962), // 148: Roundabout Node 148
  LatLng(29.43032903, 32.39886428), // 149: Roundabout Node 149
  LatLng(29.43031840, 32.39882726), // 150: Roundabout Node 150
  LatLng(29.43030352, 32.39879552), // 151: Roundabout Node 151
  LatLng(29.43028064, 32.39876665), // 152: Roundabout Node 152
  LatLng(29.42997195, 32.39884218), // 153: Road Node 153
  LatLng(29.42992508, 32.39885436), // 154: Road Node 154
  LatLng(29.42988288, 32.39885787), // 155: Reg Bump 17
  LatLng(29.42982450, 32.39885421), // 156: Road Node 156
  LatLng(29.42978552, 32.39884817), // 157: Road Node 157
  LatLng(29.42972358, 32.39883861), // 158: Road Node 158
  LatLng(29.42966932, 32.39883676), // 159: Road Node 159
  LatLng(29.42962683, 32.39883531), // 160: Road Node 160
  LatLng(29.42955011, 32.39884129), // 161: Road Node 161
  LatLng(29.42949867, 32.39885137), // 162: Road Node 162
  LatLng(29.42945327, 32.39885977), // 163: Road Node 163
  LatLng(29.42939174, 32.39887650), // 164: Road Node 164
  LatLng(29.42933811, 32.39889259), // 165: Road Node 165
  LatLng(29.42928317, 32.39891440), // 166: Road Node 166
  LatLng(29.42923733, 32.39893012), // 167: Road Node 167
  LatLng(29.42918425, 32.39895531), // 168: Road Node 168
  LatLng(29.42913089, 32.39898122), // 169: Road Node 169
  LatLng(29.42908429, 32.39900589), // 170: Road Node 170
  LatLng(29.42904570, 32.39902777), // 171: Road Node 171
  LatLng(29.42901320, 32.39904740), // 172: Road Node 172
  LatLng(29.42898273, 32.39907017), // 173: Road Node 173
  LatLng(29.42895825, 32.39908560), // 174: Road Node 174
  LatLng(29.42892239, 32.39910728), // 175: Road Node 175
  LatLng(29.42889584, 32.39912581), // 176: Road Node 176
  LatLng(29.42887722, 32.39913913), // 177: Road Node 177
  LatLng(29.42883126, 32.39915815), // 178: Road Node 178
  LatLng(29.42878065, 32.39916460), // 179: Road Node 179
  LatLng(29.42872549, 32.39916156), // 180: Road Node 180
  LatLng(29.42870727, 32.39915746), // 181: Roundabout Node 181
  LatLng(29.42868449, 32.39912710), // 182: Roundabout Node 182
  LatLng(29.42865116, 32.39910550), // 183: Roundabout Node 183
  LatLng(29.42861343, 32.39909484), // 184: Roundabout Node 184
  LatLng(29.42858978, 32.39909416), // 185: Roundabout Node 185
  LatLng(29.42855914, 32.39909658), // 186: Roundabout Node 186
  LatLng(29.42852760, 32.39910745), // 187: Roundabout Node 187
  LatLng(29.42849796, 32.39912486), // 188: Roundabout Node 188
  LatLng(29.42846745, 32.39914727), // 189: Roundabout Node 189
  LatLng(29.42844310, 32.39916788), // 190: Roundabout Node 190
  LatLng(29.42842077, 32.39919266), // 191: Roundabout Node 191
  LatLng(29.42839818, 32.39922049), // 192: Roundabout Node 192
  LatLng(29.42838327, 32.39924596), // 193: Roundabout Node 193
  LatLng(29.42836882, 32.39927039), // 194: Roundabout Node 194
  LatLng(29.42835345, 32.39930666), // 195: Roundabout Node 195
  LatLng(29.42834915, 32.39932958), // 196: Roundabout Node 196
  LatLng(29.42834534, 32.39936146), // 197: Roundabout Node 197
  LatLng(29.42834582, 32.39939034), // 198: Roundabout Node 198
  LatLng(29.42834688, 32.39941846), // 199: Roundabout Node 199
  LatLng(29.42835152, 32.39944640), // 200: Roundabout Node 200
  LatLng(29.42836053, 32.39947198), // 201: Roundabout Node 201
  LatLng(29.42837438, 32.39949245), // 202: Roundabout Node 202
  LatLng(29.42839208, 32.39950897), // 203: Roundabout Node 203
  LatLng(29.42840759, 32.39951919), // 204: Roundabout Node 204
  LatLng(29.42842601, 32.39952713), // 205: Roundabout Node 205
  LatLng(29.42845114, 32.39953422), // 206: Roundabout Node 206
  LatLng(29.42847455, 32.39953580), // 207: Roundabout Node 207
  LatLng(29.42850018, 32.39953467), // 208: Roundabout Node 208
  LatLng(29.42852683, 32.39953095), // 209: Roundabout Node 209
  LatLng(29.42854969, 32.39951971), // 210: Roundabout Node 210
  LatLng(29.42858960, 32.39948854), // 211: Roundabout Node 211
  LatLng(29.42862428, 32.39945842), // 212: Roundabout Node 212
  LatLng(29.42865677, 32.39941744), // 213: Roundabout Node 213
  LatLng(29.42868132, 32.39938037), // 214: Roundabout Node 214
  LatLng(29.42870053, 32.39934881), // 215: Roundabout Node 215
  LatLng(29.42871162, 32.39932031), // 216: Roundabout Node 216
  LatLng(29.42871943, 32.39928900), // 217: Roundabout Node 217
  LatLng(29.42872175, 32.39925911), // 218: Roundabout Node 218
  LatLng(29.42872176, 32.39923070), // 219: Roundabout Node 219
  LatLng(29.42872074, 32.39920714), // 220: Roundabout Node 220
  LatLng(29.42871650, 32.39918342), // 221: Roundabout Node 221
  LatLng(29.42839795, 32.39955175), // 222: Road Node 222
  LatLng(29.42839859, 32.39959809), // 223: Road Node 223
  LatLng(29.42839664, 32.39963928), // 224: Road Node 224
  LatLng(29.42839270, 32.39967838), // 225: Road Node 225
  LatLng(29.42837585, 32.39972141), // 226: Road Node 226
  LatLng(29.42833799, 32.39979889), // 227: Road Node 227
  LatLng(29.42831631, 32.39985026), // 228: Road Node 228
  LatLng(29.42828938, 32.39991435), // 229: Road Node 229
  LatLng(29.42826216, 32.39998049), // 230: Road Node 230
  LatLng(29.42824013, 32.40003728), // 231: Road Node 231
  LatLng(29.42822388, 32.40008032), // 232: Road Node 232
  LatLng(29.42820745, 32.40012891), // 233: Road Node 233
  LatLng(29.42819103, 32.40018185), // 234: Road Node 234
  LatLng(29.42817398, 32.40023459), // 235: Road Node 235
  LatLng(29.42815888, 32.40029422), // 236: Road Node 236
  LatLng(29.42814886, 32.40034921), // 237: Road Node 237
  LatLng(29.42813527, 32.40042003), // 238: Road Node 238
  LatLng(29.42812494, 32.40048064), // 239: Road Node 239
  LatLng(29.42811675, 32.40054872), // 240: Road Node 240
  LatLng(29.42810961, 32.40060517), // 241: Road Node 241
  LatLng(29.42810962, 32.40067370), // 242: Road Node 242
  LatLng(29.42811099, 32.40071661), // 243: Road Node 243
  LatLng(29.42811396, 32.40076127), // 244: Road Node 244
  LatLng(29.42811876, 32.40081082), // 245: Road Node 245
  LatLng(29.42813086, 32.40086832), // 246: Road Node 246
  LatLng(29.42814871, 32.40092618), // 247: Road Node 247
  LatLng(29.42816909, 32.40098518), // 248: Road Node 248
  LatLng(29.42818904, 32.40103326), // 249: Road Node 249
  LatLng(29.42820396, 32.40111624), // 250: Spiked Bump 10
  LatLng(29.42820956, 32.40117569), // 251: Road Node 251
  LatLng(29.42820103, 32.40121567), // 252: Roundabout Node 252
  LatLng(29.42817624, 32.40124507), // 253: Roundabout Node 253
  LatLng(29.42815132, 32.40128738), // 254: Roundabout Node 254
  LatLng(29.42813981, 32.40133406), // 255: Roundabout Node 255
  LatLng(29.42813512, 32.40138985), // 256: Roundabout Node 256
  LatLng(29.42813982, 32.40143383), // 257: Roundabout Node 257
  LatLng(29.42815005, 32.40147529), // 258: Roundabout Node 258
  LatLng(29.42816440, 32.40150895), // 259: Roundabout Node 259
  LatLng(29.42818469, 32.40153385), // 260: Roundabout Node 260
  LatLng(29.42820707, 32.40155428), // 261: Roundabout Node 261
  LatLng(29.42823224, 32.40157323), // 262: Roundabout Node 262
  LatLng(29.42826806, 32.40159236), // 263: Roundabout Node 263
  LatLng(29.42829544, 32.40159799), // 264: Roundabout Node 264
  LatLng(29.42833152, 32.40160301), // 265: Roundabout Node 265
  LatLng(29.42835704, 32.40159862), // 266: Roundabout Node 266
  LatLng(29.42838789, 32.40158848), // 267: Roundabout Node 267
  LatLng(29.42841799, 32.40157407), // 268: Roundabout Node 268
  LatLng(29.42844604, 32.40154749), // 269: Roundabout Node 269
  LatLng(29.42846741, 32.40151196), // 270: Roundabout Node 270
  LatLng(29.42849198, 32.40146972), // 271: Roundabout Node 271
  LatLng(29.42850019, 32.40143143), // 272: Roundabout Node 272
  LatLng(29.42850182, 32.40139502), // 273: Roundabout Node 273
  LatLng(29.42849980, 32.40136094), // 274: Roundabout Node 274
  LatLng(29.42849404, 32.40132906), // 275: Roundabout Node 275
  LatLng(29.42848248, 32.40129264), // 276: Roundabout Node 276
  LatLng(29.42845714, 32.40125500), // 277: Roundabout Node 277
  LatLng(29.42842268, 32.40122972), // 278: Roundabout Node 278
  LatLng(29.42838327, 32.40120591), // 279: Roundabout Node 279
  LatLng(29.42834380, 32.40119484), // 280: Roundabout Node 280
  LatLng(29.42830053, 32.40118719), // 281: Roundabout Node 281
  LatLng(29.42826347, 32.40119290), // 282: Roundabout Node 282
  LatLng(29.42823525, 32.40120177), // 283: Roundabout Node 283
  LatLng(29.42814645, 32.40153748), // 284: Road Node 284
  LatLng(29.42813440, 32.40158125), // 285: Road Node 285
  LatLng(29.42811261, 32.40162347), // 286: Road Node 286
  LatLng(29.42808516, 32.40166870), // 287: Road Node 287
  LatLng(29.42796127, 32.40186197), // 288: Pharmacy Station (Node 288)
  LatLng(29.42784736, 32.40202995), // 289: Pharmacy Station (Node 289)
  LatLng(29.42770783, 32.40224199), // 290: Road Node 290
  LatLng(29.42754195, 32.40248987), // 291: Reg Bump 9
  LatLng(29.42739400, 32.40271556), // 292: Nursing Station (Node 292)
  LatLng(29.42724215, 32.40294103), // 293: Road Node 293
  LatLng(29.42708905, 32.40317171), // 294: Road Node 294
  LatLng(29.42698531, 32.40331822), // 295: Road Node 295
  LatLng(29.42693022, 32.40339359), // 296: Road Node 296
  LatLng(29.42687864, 32.40345543), // 297: Road Node 297
  LatLng(29.42683288, 32.40350388), // 298: Road Node 298
  LatLng(29.42678835, 32.40355199), // 299: Road Node 299
  LatLng(29.42673339, 32.40360287), // 300: Road Node 300
  LatLng(29.42665986, 32.40366230), // 301: Spiked Bump 11
  LatLng(29.42660981, 32.40369548), // 302: Road Node 302
  LatLng(29.42657454, 32.40371430), // 303: Road Node 303
  LatLng(29.42654323, 32.40371427), // 304: Roundabout Node 304
  LatLng(29.42651175, 32.40371311), // 305: Roundabout Node 305
  LatLng(29.42647105, 32.40369775), // 306: Roundabout Node 306
  LatLng(29.42644248, 32.40369645), // 307: Roundabout Node 307
  LatLng(29.42641602, 32.40370130), // 308: Roundabout Node 308
  LatLng(29.42638350, 32.40371258), // 309: Roundabout Node 309
  LatLng(29.42634892, 32.40373936), // 310: Roundabout Node 310
  LatLng(29.42632721, 32.40376821), // 311: Roundabout Node 311
  LatLng(29.42630979, 32.40380131), // 312: Roundabout Node 312
  LatLng(29.42629410, 32.40384528), // 313: Roundabout Node 313
  LatLng(29.42629166, 32.40388472), // 314: Roundabout Node 314
  LatLng(29.42629941, 32.40392253), // 315: Roundabout Node 315
  LatLng(29.42631154, 32.40395974), // 316: Roundabout Node 316
  LatLng(29.42632549, 32.40399043), // 317: Roundabout Node 317
  LatLng(29.42634483, 32.40401459), // 318: Roundabout Node 318
  LatLng(29.42636762, 32.40402971), // 319: Roundabout Node 319
  LatLng(29.42639539, 32.40404512), // 320: Roundabout Node 320
  LatLng(29.42641669, 32.40405226), // 321: Medical Station (Node 321)
  LatLng(29.42644014, 32.40405590), // 322: Medical Station (Node 322)
  LatLng(29.42646772, 32.40405242), // 323: Medical Station (Node 323)
  LatLng(29.42649439, 32.40404692), // 324: Medical Station (Node 324)
  LatLng(29.42652169, 32.40403077), // 325: Medical Station (Node 325)
  LatLng(29.42654577, 32.40400374), // 326: Medical Station (Node 326)
  LatLng(29.42656959, 32.40396903), // 327: Medical Station (Node 327)
  LatLng(29.42658185, 32.40394575), // 328: Medical Station (Node 328)
  LatLng(29.42659324, 32.40391264), // 329: Medical Station (Node 329)
  LatLng(29.42659987, 32.40388355), // 330: Medical Station (Node 330)
  LatLng(29.42660014, 32.40386176), // 331: Medical Station (Node 331)
  LatLng(29.42659853, 32.40383329), // 332: Medical Station (Node 332)
  LatLng(29.42658817, 32.40380244), // 333: Roundabout Node 333
  LatLng(29.42657354, 32.40377145), // 334: Roundabout Node 334
  LatLng(29.42655797, 32.40374851), // 335: Roundabout Node 335
  LatLng(29.42646660, 32.40408199), // 336: Medical Station (Node 336)
  LatLng(29.42649551, 32.40411815), // 337: Medical Station (Node 337)
  LatLng(29.42651477, 32.40414978), // 338: Medical Station (Node 338)
  LatLng(29.42653558, 32.40419522), // 339: Medical Station (Node 339)
  LatLng(29.42655321, 32.40424163), // 340: Medical Station (Node 340)
  LatLng(29.42656740, 32.40428390), // 341: Road Node 341
  LatLng(29.42658331, 32.40432735), // 342: Road Node 342
  LatLng(29.42659646, 32.40436343), // 343: Road Node 343
  LatLng(29.42660684, 32.40439276), // 344: Road Node 344
  LatLng(29.42661932, 32.40442210), // 345: Road Node 345
  LatLng(29.42663293, 32.40445482), // 346: Road Node 346
  LatLng(29.42664842, 32.40448757), // 347: Road Node 347
  LatLng(29.42666695, 32.40452299), // 348: Road Node 348
  LatLng(29.42668223, 32.40455203), // 349: Road Node 349
  LatLng(29.42670658, 32.40458816), // 350: Road Node 350
  LatLng(29.42673673, 32.40462655), // 351: Road Node 351
  LatLng(29.42675658, 32.40464944), // 352: Road Node 352
  LatLng(29.42677575, 32.40467294), // 353: Road Node 353
  LatLng(29.42679895, 32.40470027), // 354: Road Node 354
  LatLng(29.42681970, 32.40472315), // 355: Road Node 355
  LatLng(29.42686409, 32.40477322), // 356: Road Node 356
  LatLng(29.42689075, 32.40480252), // 357: Road Node 357
  LatLng(29.42692939, 32.40484675), // 358: Road Node 358
  LatLng(29.42695864, 32.40487815), // 359: Road Node 359
  LatLng(29.42699348, 32.40491916), // 360: Road Node 360
  LatLng(29.42704056, 32.40497385), // 361: Road Node 361
  LatLng(29.42710273, 32.40504999), // 362: Road Node 362
  LatLng(29.42720766, 32.40517251), // 363: Road Node 363
  LatLng(29.42729766, 32.40527141), // 364: Road Node 364
  LatLng(29.42740217, 32.40538871), // 365: Road Node 365
  LatLng(29.42749193, 32.40548861), // 366: Road Node 366
  LatLng(29.42754453, 32.40555034), // 367: Road Node 367
  LatLng(29.42760512, 32.40561733), // 368: Road Node 368
  LatLng(29.42766738, 32.40568936), // 369: Road Node 369
  LatLng(29.42776274, 32.40579664), // 370: Turn Corner2 Node 370
  LatLng(29.42781671, 32.40586155), // 371: Turn Corner2 Node 371
  LatLng(29.42786830, 32.40591697), // 372: Turn Corner2 Node 372
  LatLng(29.42789440, 32.40593354), // 373: Turn Corner2 Node 373
  LatLng(29.42792555, 32.40594460), // 374: Turn Corner2 Node 374
  LatLng(29.42795230, 32.40594871), // 375: Turn Corner2 Node 375
  LatLng(29.42798809, 32.40594644), // 376: Turn Corner2 Node 376
  LatLng(29.42801773, 32.40594224), // 377: Turn Corner2 Node 377
  LatLng(29.42804608, 32.40593413), // 378: Turn Corner2 Node 378
  LatLng(29.42806913, 32.40592300), // 379: Turn Corner2 Node 379
  LatLng(29.42809580, 32.40590460), // 380: Turn Corner2 Node 380
  LatLng(29.42812888, 32.40587113), // 381: Turn Corner2 Node 381
  LatLng(29.42815438, 32.40584166), // 382: Turn Corner2 Node 382
  LatLng(29.42817949, 32.40580667), // 383: Reg Bump 4
  LatLng(29.42822707, 32.40574478), // 384: Dentistry Station (Node 384)
  LatLng(29.42826372, 32.40569520), // 385: Dentistry Station (Node 385)
  LatLng(29.42829660, 32.40564928), // 386: Dentistry Station (Node 386)
  LatLng(29.42833477, 32.40559378), // 387: Dentistry Station (Node 387)
  LatLng(29.42837011, 32.40554209), // 388: Dentistry Station (Node 388)
  LatLng(29.42843097, 32.40545625), // 389: Dentistry Station (Node 389)
  LatLng(29.42847473, 32.40539316), // 390: Road Node 390
  LatLng(29.42852920, 32.40531335), // 391: Road Node 391
  LatLng(29.42857442, 32.40524325), // 392: Road Node 392
  LatLng(29.42862942, 32.40516129), // 393: Road Node 393
  LatLng(29.42869505, 32.40506023), // 394: Road Node 394
  LatLng(29.42875564, 32.40496937), // 395: Road Node 395
  LatLng(29.42881228, 32.40488207), // 396: Road Node 396
  LatLng(29.42886440, 32.40480659), // 397: Road Node 397
  LatLng(29.42892034, 32.40472344), // 398: Road Node 398
  LatLng(29.42897518, 32.40464545), // 399: Road Node 399
  LatLng(29.42903249, 32.40456509), // 400: Road Node 400
  LatLng(29.42911350, 32.40444853), // 401: Road Node 401
  LatLng(29.42919450, 32.40433172), // 402: Physical Therapy Station (Node 402)
  LatLng(29.42925343, 32.40424369), // 403: Physical Therapy Station (Node 403)
  LatLng(29.42932714, 32.40413575), // 404: Physical Therapy Station (Node 404)
  LatLng(29.42939127, 32.40403715), // 405: Physical Therapy Station (Node 405)
  LatLng(29.42944706, 32.40395213), // 406: Road Node 406
  LatLng(29.42949888, 32.40387871), // 407: Road Node 407
  LatLng(29.42954491, 32.40381340), // 408: Road Node 408
  LatLng(29.42962036, 32.40371353), // 409: Road Node 409
  LatLng(29.42966999, 32.40364850), // 410: Road Node 410
  LatLng(29.42972422, 32.40357132), // 411: Road Node 411
  LatLng(29.42979496, 32.40346923), // 412: Road Node 412
  LatLng(29.42988783, 32.40333857), // 413: Applied Health Station (Node 413)
  LatLng(29.42996975, 32.40322360), // 414: Applied Health Station (Node 414)
  LatLng(29.43003750, 32.40313742), // 415: Applied Health Station (Node 415)
  LatLng(29.43010402, 32.40304742), // 416: Applied Health Station (Node 416)
  LatLng(29.43019735, 32.40291783), // 417: Road Node 417
  LatLng(29.43027170, 32.40281426), // 418: Road Node 418
  LatLng(29.43033822, 32.40272283), // 419: Road Node 419
  LatLng(29.43039250, 32.40265251), // 420: Road Node 420
  LatLng(29.43048046, 32.40252638), // 421: Road Node 421
  LatLng(29.43058724, 32.40237711), // 422: Road Node 422
  LatLng(29.43065518, 32.40228227), // 423: Road Node 423
  LatLng(29.43073180, 32.40217917), // 424: Road Node 424
  LatLng(29.43082925, 32.40205429), // 425: Road Node 425
  LatLng(29.43092738, 32.40193255), // 426: Road Node 426
  LatLng(29.43107240, 32.40176072), // 427: Admission Station (Node 427)
  LatLng(29.43115126, 32.40165380), // 428: Admission Station (Node 428)
  LatLng(29.43079556, 32.40205132), // 429: Road Node 429
  LatLng(29.43075410, 32.40210289), // 430: Road Node 430
  LatLng(29.43067317, 32.40220853), // 431: Road Node 431
  LatLng(29.43062088, 32.40228529), // 432: Road Node 432
  LatLng(29.43053106, 32.40240724), // 433: Road Node 433
  LatLng(29.43044686, 32.40252938), // 434: Road Node 434
  LatLng(29.43038226, 32.40261571), // 435: Road Node 435
  LatLng(29.43031730, 32.40271032), // 436: Road Node 436
  LatLng(29.43026111, 32.40278528), // 437: Road Node 437
  LatLng(29.43019446, 32.40287930), // 438: Road Node 438
  LatLng(29.43012707, 32.40296419), // 439: Road Node 439
  LatLng(29.43006463, 32.40305309), // 440: Applied Health Station (Node 440)
  LatLng(29.42998180, 32.40316778), // 441: Applied Health Station (Node 441)
  LatLng(29.42990349, 32.40326752), // 442: Applied Health Station (Node 442)
  LatLng(29.42981520, 32.40339274), // 443: Road Node 443
  LatLng(29.42971065, 32.40353947), // 444: Road Node 444
  LatLng(29.42962150, 32.40365938), // 445: Road Node 445
  LatLng(29.42954237, 32.40377487), // 446: Road Node 446
  LatLng(29.42947358, 32.40386623), // 447: Road Node 447
  LatLng(29.42937434, 32.40401921), // 448: Physical Therapy Station (Node 448)
  LatLng(29.42928356, 32.40415616), // 449: Physical Therapy Station (Node 449)
  LatLng(29.42922295, 32.40424358), // 450: Physical Therapy Station (Node 450)
  LatLng(29.42904986, 32.40449120), // 451: Road Node 451
  LatLng(29.42896300, 32.40461368), // 452: Road Node 452
  LatLng(29.42888254, 32.40473681), // 453: Road Node 453
  LatLng(29.42878990, 32.40487455), // 454: Road Node 454
  LatLng(29.42868883, 32.40502020), // 455: Road Node 455
  LatLng(29.42859791, 32.40515836), // 456: Road Node 456
  LatLng(29.42852964, 32.40525991), // 457: Road Node 457
  LatLng(29.42844828, 32.40537963), // 458: Road Node 458
  LatLng(29.42836383, 32.40550296), // 459: Dentistry Station (Node 459)
  LatLng(29.42828960, 32.40561523), // 460: Dentistry Station (Node 460)
  LatLng(29.42821244, 32.40572487), // 461: Dentistry Station (Node 461)
  LatLng(29.42814211, 32.40582287), // 462: Road Node 462
  LatLng(29.42811414, 32.40585580), // 463: Road Node 463
  LatLng(29.42808516, 32.40587954), // 464: Road Node 464
  LatLng(29.42804787, 32.40590263), // 465: Road Node 465
  LatLng(29.42800541, 32.40591519), // 466: Road Node 466
  LatLng(29.42796549, 32.40591403), // 467: Road Node 467
  LatLng(29.42793310, 32.40590787), // 468: Road Node 468
  LatLng(29.42790822, 32.40589834), // 469: Road Node 469
  LatLng(29.42788821, 32.40588697), // 470: Road Node 470
  LatLng(29.42786724, 32.40587058), // 471: Road Node 471
  LatLng(29.42783984, 32.40584636), // 472: Road Node 472
  LatLng(29.42782165, 32.40582602), // 473: Road Node 473
  LatLng(29.42779516, 32.40579630), // 474: Reg Bump 5
  LatLng(29.42777121, 32.40577107), // 475: Road Node 475
  LatLng(29.42774815, 32.40574652), // 476: Road Node 476
  LatLng(29.42772403, 32.40571665), // 477: Road Node 477
  LatLng(29.42769531, 32.40568471), // 478: Road Node 478
  LatLng(29.42766595, 32.40565418), // 479: Road Node 479
  LatLng(29.42760966, 32.40559178), // 480: Road Node 480
  LatLng(29.42757966, 32.40555752), // 481: Road Node 481
  LatLng(29.42755196, 32.40552331), // 482: Road Node 482
  LatLng(29.42752211, 32.40548915), // 483: Road Node 483
  LatLng(29.42748357, 32.40544800), // 484: Road Node 484
  LatLng(29.42745472, 32.40541218), // 485: Road Node 485
  LatLng(29.42736881, 32.40531337), // 486: Road Node 486
  LatLng(29.42728676, 32.40521796), // 487: Road Node 487
  LatLng(29.42722517, 32.40514511), // 488: Road Node 488
  LatLng(29.42716493, 32.40507803), // 489: Road Node 489
  LatLng(29.42709541, 32.40500114), // 490: Road Node 490
  LatLng(29.42702328, 32.40491441), // 491: Road Node 491
  LatLng(29.42694621, 32.40482906), // 492: Road Node 492
  LatLng(29.42687233, 32.40474668), // 493: Road Node 493
  LatLng(29.42681905, 32.40468136), // 494: Road Node 494
  LatLng(29.42676506, 32.40461834), // 495: Road Node 495
  LatLng(29.42671047, 32.40454911), // 496: Road Node 496
  LatLng(29.42667181, 32.40447610), // 497: Road Node 497
  LatLng(29.42664271, 32.40441143), // 498: Road Node 498
  LatLng(29.42660984, 32.40432518), // 499: Road Node 499
  LatLng(29.42658713, 32.40426804), // 500: Road Node 500
  LatLng(29.42655457, 32.40416349), // 501: Medical Station (Node 501)
  LatLng(29.42653732, 32.40410730), // 502: Medical Station (Node 502)
  LatLng(29.42653801, 32.40406899), // 503: Medical Station (Node 503)
  LatLng(29.42662262, 32.40382923), // 504: Medical Station (Node 504)
  LatLng(29.42663912, 32.40380233), // 505: Road Node 505
  LatLng(29.42666534, 32.40376846), // 506: Road Node 506
  LatLng(29.42669689, 32.40373919), // 507: Road Node 507
  LatLng(29.42672652, 32.40371395), // 508: Road Node 508
  LatLng(29.42676832, 32.40367576), // 509: Road Node 509
  LatLng(29.42681843, 32.40362517), // 510: Road Node 510
  LatLng(29.42687776, 32.40356554), // 511: Road Node 511
  LatLng(29.42693369, 32.40350263), // 512: Road Node 512
  LatLng(29.42699698, 32.40342390), // 513: Road Node 513
  LatLng(29.42703849, 32.40336927), // 514: Road Node 514
  LatLng(29.42707901, 32.40331167), // 515: Road Node 515
  LatLng(29.42715684, 32.40320093), // 516: Road Node 516
  LatLng(29.42720967, 32.40312085), // 517: Road Node 517
  LatLng(29.42729065, 32.40300200), // 518: Nursing Station (Node 518)
  LatLng(29.42736469, 32.40289530), // 519: Nursing Station (Node 519)
  LatLng(29.42742306, 32.40280592), // 520: Nursing Station (Node 520)
  LatLng(29.42748216, 32.40271330), // 521: Nursing Station (Node 521)
  LatLng(29.42758047, 32.40255976), // 522: Road Node 522
  LatLng(29.42768757, 32.40239804), // 523: Road Node 523
  LatLng(29.42779043, 32.40224258), // 524: Road Node 524
  LatLng(29.42786636, 32.40213122), // 525: Pharmacy Station (Node 525)
  LatLng(29.42794260, 32.40201435), // 526: Pharmacy Station (Node 526)
  LatLng(29.42801924, 32.40190099), // 527: Pharmacy Station (Node 527)
  LatLng(29.42807931, 32.40181549), // 528: Pharmacy Station (Node 528)
  LatLng(29.42815731, 32.40170518), // 529: Road Node 529
  LatLng(29.42821728, 32.40164609), // 530: Spiked Bump 9
  LatLng(29.42827131, 32.40162256), // 531: Road Node 531
  LatLng(29.42831120, 32.40160959), // 532: Road Node 532
  LatLng(29.42852632, 32.40142987), // 533: Road Node 533
  LatLng(29.42856561, 32.40140978), // 534: Road Node 534
  LatLng(29.42860591, 32.40139573), // 535: Road Node 535
  LatLng(29.42865254, 32.40139087), // 536: Road Node 536
  LatLng(29.42876121, 32.40138087), // 537: Road Node 537
  LatLng(29.42882831, 32.40137632), // 538: Road Node 538
  LatLng(29.42894129, 32.40135114), // 539: Road Node 539
  LatLng(29.42908214, 32.40130802), // 540: Road Node 540
  LatLng(29.42920301, 32.40125051), // 541: Road Node 541
  LatLng(29.42937485, 32.40115803), // 542: Road Node 542
  LatLng(29.42948849, 32.40107782), // 543: Road Node 543
  LatLng(29.42958723, 32.40099788), // 544: Road Node 544
  LatLng(29.42967558, 32.40090982), // 545: Reg Bump 12
  LatLng(29.42977161, 32.40080338), // 546: Road Node 546
  LatLng(29.42983324, 32.40072767), // 547: Road Node 547
  LatLng(29.42991969, 32.40060570), // 548: Road Node 548
  LatLng(29.42998426, 32.40049927), // 549: Road Node 549
  LatLng(29.43003691, 32.40040429), // 550: Road Node 550
  LatLng(29.43008497, 32.40029597), // 551: Road Node 551
  LatLng(29.43014334, 32.40014765), // 552: Road Node 552
  LatLng(29.43018389, 32.40000735), // 553: Road Node 553
  LatLng(29.43021318, 32.39987204), // 554: Road Node 554
  LatLng(29.43023914, 32.39969465), // 555: Road Node 555
  LatLng(29.43025190, 32.39953710), // 556: CS & Eng Station (Node 556)
  LatLng(29.43024508, 32.39937072), // 557: CS & Eng Station (Node 557)
  LatLng(29.43022445, 32.39926706), // 558: CS & Eng Station (Node 558)
  LatLng(29.43022485, 32.39918450), // 559: CS & Eng Station (Node 559)
  LatLng(29.43024192, 32.39913879), // 560: CS & Eng Station (Node 560)
  LatLng(29.43027212, 32.39909086), // 561: Road Node 561
  LatLng(29.43034162, 32.39881113), // 562: Road Node 562
  LatLng(29.43036048, 32.39876421), // 563: Road Node 563
  LatLng(29.43040411, 32.39870613), // 564: Reg Bump 18
  LatLng(29.43046114, 32.39863522), // 565: Road Node 565
  LatLng(29.43051921, 32.39856649), // 566: Road Node 566
  LatLng(29.43059681, 32.39848199), // 567: Road Node 567
  LatLng(29.43069644, 32.39836288), // 568: Road Node 568
  LatLng(29.43078142, 32.39826189), // 569: Road Node 569
  LatLng(29.43088013, 32.39814868), // 570: Road Node 570
  LatLng(29.43095617, 32.39806164), // 571: Road Node 571
  LatLng(29.43106280, 32.39793669), // 572: Spiked Bump 4
  LatLng(29.43116648, 32.39781747), // 573: Road Node 573
  LatLng(29.43127799, 32.39768850), // 574: Road Node 574
  LatLng(29.43138897, 32.39755634), // 575: Road Node 575
  LatLng(29.43152286, 32.39739194), // 576: Road Node 576
  LatLng(29.43164681, 32.39724097), // 577: Road Node 577
  LatLng(29.43174167, 32.39712318), // 578: Road Node 578
  LatLng(29.43182338, 32.39702449), // 579: Road Node 579
  LatLng(29.43188450, 32.39695162), // 580: Reg Bump 20
  LatLng(29.43194685, 32.39687502), // 581: Road Node 581
  LatLng(29.43197581, 32.39685005), // 582: Spiked Bump 6
  LatLng(29.43199959, 32.39683251), // 583: Road Node 583
  LatLng(29.43203333, 32.39681642), // 584: Road Node 584
  LatLng(29.43206039, 32.39680841), // 585: Road Node 585
  LatLng(29.43235251, 32.39674222), // 586: Road Node 586
  LatLng(29.43239040, 32.39674202), // 587: Road Node 587
  LatLng(29.43242378, 32.39675231), // 588: Road Node 588
  LatLng(29.43245656, 32.39676854), // 589: Road Node 589
  LatLng(29.43249261, 32.39678474), // 590: Road Node 590
  LatLng(29.43254150, 32.39680831), // 591: Road Node 591
  LatLng(29.43257984, 32.39682664), // 592: Road Node 592
  LatLng(29.43262669, 32.39685221), // 593: Road Node 593
  LatLng(29.43267692, 32.39688474), // 594: Road Node 594
  LatLng(29.43271970, 32.39691592), // 595: Road Node 595
  LatLng(29.43275811, 32.39694154), // 596: Arts & Design Station (Node 596)
  LatLng(29.43279507, 32.39697364), // 597: Arts & Design Station (Node 597)
  LatLng(29.43282870, 32.39700626), // 598: Arts & Design Station (Node 598)
  LatLng(29.43285222, 32.39703265), // 599: Arts & Design Station (Node 599)
  LatLng(29.43288092, 32.39706283), // 600: Arts & Design Station (Node 600)
  LatLng(29.43292068, 32.39710787), // 601: Arts & Design Station (Node 601)
  LatLng(29.43298051, 32.39717270), // 602: Arts & Design Station (Node 602)
  LatLng(29.43302264, 32.39721390), // 603: Arts & Design Station (Node 603)
  LatLng(29.43305357, 32.39724751), // 604: Road Node 604
  LatLng(29.43309579, 32.39729710), // 605: Road Node 605
  LatLng(29.43313828, 32.39734186), // 606: Road Node 606
  LatLng(29.43319774, 32.39741035), // 607: Road Node 607
  LatLng(29.43324178, 32.39745981), // 608: Road Node 608
  LatLng(29.43329266, 32.39751339), // 609: Road Node 609
  LatLng(29.43333813, 32.39756603), // 610: Road Node 610
  LatLng(29.43337701, 32.39760971), // 611: Road Node 611
  LatLng(29.43342150, 32.39765081), // 612: Engineering Station (Node 612)
  LatLng(29.43347617, 32.39771058), // 613: Engineering Station (Node 613)
  LatLng(29.43349117, 32.39774832), // 614: Engineering Station (Node 614)
  LatLng(29.43351948, 32.39778087), // 615: Engineering Station (Node 615)
  LatLng(29.43355847, 32.39782279), // 616: Engineering Station (Node 616)
  LatLng(29.43359937, 32.39786689), // 617: Engineering Station (Node 617)
  LatLng(29.43363570, 32.39791041), // 618: Engineering Station (Node 618)
  LatLng(29.43367773, 32.39796172), // 619: Engineering Station (Node 619)
  LatLng(29.43371557, 32.39800413), // 620: Road Node 620
  LatLng(29.43374102, 32.39803126), // 621: Road Node 621
  LatLng(29.43377172, 32.39807386), // 622: Road Node 622
  LatLng(29.43378942, 32.39810509), // 623: Road Node 623
  LatLng(29.43380090, 32.39813519), // 624: Road Node 624
  LatLng(29.43380826, 32.39816936), // 625: Road Node 625
  LatLng(29.43381286, 32.39820052), // 626: Road Node 626
  LatLng(29.43381449, 32.39822980), // 627: Road Node 627
  LatLng(29.43380812, 32.39826703), // 628: Road Node 628
  LatLng(29.43380267, 32.39829816), // 629: Road Node 629
  LatLng(29.43379080, 32.39833205), // 630: Road Node 630
  LatLng(29.43377248, 32.39837029), // 631: Road Node 631
  LatLng(29.43373936, 32.39841374), // 632: Reg Bump 2
  LatLng(29.43369119, 32.39846428), // 633: Road Node 633
  LatLng(29.43364440, 32.39851834), // 634: Road Node 634
  LatLng(29.43360883, 32.39856022), // 635: Road Node 635
  LatLng(29.43357135, 32.39860063), // 636: Road Node 636
  LatLng(29.43353059, 32.39864322), // 637: Road Node 637
  LatLng(29.43346032, 32.39872502), // 638: Road Node 638
  LatLng(29.43339381, 32.39880603), // 639: Road Node 639
  LatLng(29.43333645, 32.39886986), // 640: Road Node 640
  LatLng(29.43327399, 32.39893748), // 641: Road Node 641
  LatLng(29.43320948, 32.39900985), // 642: Road Node 642
  LatLng(29.43314509, 32.39907769), // 643: Road Node 643
  LatLng(29.43308386, 32.39914351), // 644: Road Node 644
  LatLng(29.43302402, 32.39920818), // 645: Road Node 645
  LatLng(29.43294314, 32.39929192), // 646: Road Node 646
  LatLng(29.43288077, 32.39936140), // 647: Road Node 647
  LatLng(29.43282439, 32.39941931), // 648: Road Node 648
  LatLng(29.43276847, 32.39947934), // 649: Road Node 649
  LatLng(29.43272647, 32.39952763), // 650: Road Node 650
  LatLng(29.43267612, 32.39958602), // 651: Road Node 651
  LatLng(29.43263212, 32.39963428), // 652: Road Node 652
  LatLng(29.43258028, 32.39969206), // 653: Road Node 653
  LatLng(29.43252913, 32.39975747), // 654: Road Node 654
  LatLng(29.43246694, 32.39983798), // 655: Road Node 655
  LatLng(29.43241515, 32.39990548), // 656: Road Node 656
  LatLng(29.43237115, 32.39996162), // 657: Road Node 657
  LatLng(29.43229891, 32.40004941), // 658: Road Node 658
  LatLng(29.43221663, 32.40015324), // 659: Road Node 659
  LatLng(29.43215972, 32.40022942), // 660: Road Node 660
  LatLng(29.43209958, 32.40030956), // 661: Road Node 661
  LatLng(29.43205367, 32.40036918), // 662: Road Node 662
  LatLng(29.43199228, 32.40044346), // 663: Science Station (Node 663)
  LatLng(29.43192535, 32.40053784), // 664: Science Station (Node 664)
  LatLng(29.43187730, 32.40059634), // 665: Science Station (Node 665)
  LatLng(29.43176336, 32.40074979), // 666: Road Node 666
  LatLng(29.43169668, 32.40083369), // 667: Road Node 667
  LatLng(29.43162532, 32.40092748), // 668: Road Node 668
  LatLng(29.43154656, 32.40102428), // 669: Road Node 669
  LatLng(29.43148286, 32.40111522), // 670: Road Node 670
  LatLng(29.43140152, 32.40122235), // 671: Road Node 671
  LatLng(29.43132875, 32.40132830), // 672: Road Node 672
  LatLng(29.43125751, 32.40142301), // 673: Road Node 673
  LatLng(29.43118721, 32.40153167), // 674: Admission Station (Node 674)
  LatLng(29.43107812, 32.40167970), // 675: Admission Station (Node 675)
  LatLng(29.43101090, 32.40177829), // 676: Admission Station (Node 676)
  LatLng(29.43097698, 32.40185004), // 677: Admission Station (Node 677)
  LatLng(29.43087474, 32.40197356), // 678: Road Node 678
  LatLng(29.43084128, 32.40201683), // 679: Road Node 679
  LatLng(29.43081376, 32.40203863), // 680: Road Node 680
  LatLng(29.42837547, 32.40118353), // 681: Road Node 681
  LatLng(29.42833980, 32.40113254), // 682: Road Node 682
  LatLng(29.42829900, 32.40107085), // 683: Road Node 683
  LatLng(29.42826520, 32.40100111), // 684: Road Node 684
  LatLng(29.42822077, 32.40089837), // 685: Road Node 685
  LatLng(29.42820330, 32.40081578), // 686: Road Node 686
  LatLng(29.42819033, 32.40070607), // 687: Road Node 687
  LatLng(29.42819612, 32.40059954), // 688: Road Node 688
  LatLng(29.42819797, 32.40050797), // 689: Road Node 689
  LatLng(29.42820706, 32.40042612), // 690: Road Node 690
  LatLng(29.42822487, 32.40034222), // 691: Road Node 691
  LatLng(29.42823904, 32.40028751), // 692: Road Node 692
  LatLng(29.42825973, 32.40021104), // 693: Road Node 693
  LatLng(29.42828809, 32.40011430), // 694: Road Node 694
  LatLng(29.42831613, 32.40004388), // 695: Road Node 695
  LatLng(29.42834082, 32.39997887), // 696: Road Node 696
  LatLng(29.42836325, 32.39993101), // 697: Road Node 697
  LatLng(29.42839978, 32.39984349), // 698: Road Node 698
  LatLng(29.42843388, 32.39978363), // 699: Road Node 699
  LatLng(29.42847627, 32.39971178), // 700: Road Node 700
  LatLng(29.42851039, 32.39964927), // 701: Road Node 701
  LatLng(29.42853628, 32.39959089), // 702: Road Node 702
  LatLng(29.42855220, 32.39955738), // 703: Road Node 703
  LatLng(29.42856230, 32.39953615), // 704: Road Node 704
  LatLng(29.42872305, 32.39935455), // 705: Road Node 705
  LatLng(29.42878942, 32.39930644), // 706: Road Node 706
  LatLng(29.42885794, 32.39925846), // 707: Road Node 707
  LatLng(29.42893324, 32.39920513), // 708: Road Node 708
  LatLng(29.42900581, 32.39915206), // 709: Road Node 709
  LatLng(29.42907472, 32.39910668), // 710: Road Node 710
  LatLng(29.42913181, 32.39907347), // 711: Road Node 711
  LatLng(29.42919495, 32.39904005), // 712: Road Node 712
  LatLng(29.42925952, 32.39901047), // 713: Road Node 713
  LatLng(29.42931459, 32.39899289), // 714: Road Node 714
  LatLng(29.42936791, 32.39896946), // 715: Road Node 715
  LatLng(29.42943049, 32.39895579), // 716: Road Node 716
  LatLng(29.42951698, 32.39893431), // 717: Road Node 717
  LatLng(29.42960220, 32.39891866), // 718: Road Node 718
  LatLng(29.42967817, 32.39891908), // 719: Road Node 719
  LatLng(29.42974552, 32.39892828), // 720: Road Node 720
  LatLng(29.42981712, 32.39894698), // 721: Reg Bump 15
  LatLng(29.42991372, 32.39899181), // 722: Road Node 722
  LatLng(29.42995884, 32.39900865), // 723: Road Node 723
  LatLng(29.42999535, 32.39902177), // 724: Road Node 724
  LatLng(29.43008839, 32.39913334), // 725: Road Node 725
  LatLng(29.43011086, 32.39919991), // 726: Road Node 726
  LatLng(29.43013059, 32.39926419), // 727: CS & Eng Station (Node 727)
  LatLng(29.43014967, 32.39933596), // 728: CS & Eng Station (Node 728)
  LatLng(29.43016826, 32.39941447), // 729: CS & Eng Station (Node 729)
  LatLng(29.43018025, 32.39948429), // 730: CS & Eng Station (Node 730)
  LatLng(29.43018057, 32.39955815), // 731: Road Node 731
  LatLng(29.43017377, 32.39963527), // 732: Road Node 732
  LatLng(29.43016499, 32.39970236), // 733: Road Node 733
  LatLng(29.43015784, 32.39975695), // 734: Road Node 734
  LatLng(29.43014729, 32.39981882), // 735: Road Node 735
  LatLng(29.43012920, 32.39990581), // 736: Road Node 736
  LatLng(29.43011454, 32.39998125), // 737: Road Node 737
  LatLng(29.43009869, 32.40003165), // 738: Road Node 738
  LatLng(29.43007731, 32.40009274), // 739: Road Node 739
  LatLng(29.43004968, 32.40017294), // 740: Road Node 740
  LatLng(29.43002179, 32.40025491), // 741: Road Node 741
  LatLng(29.42998946, 32.40033052), // 742: Road Node 742
  LatLng(29.42995557, 32.40040138), // 743: Road Node 743
  LatLng(29.42990662, 32.40048387), // 744: Road Node 744
  LatLng(29.42986189, 32.40055710), // 745: Road Node 745
  LatLng(29.42980954, 32.40063457), // 746: Road Node 746
  LatLng(29.42975799, 32.40070205), // 747: Road Node 747
  LatLng(29.42968621, 32.40078713), // 748: Road Node 748
  LatLng(29.42959834, 32.40087823), // 749: Road Node 749
  LatLng(29.42952137, 32.40094990), // 750: Road Node 750
  LatLng(29.42943975, 32.40101698), // 751: Road Node 751
  LatLng(29.42938100, 32.40105858), // 752: Road Node 752
  LatLng(29.42927888, 32.40112372), // 753: Road Node 753
  LatLng(29.42918345, 32.40117239), // 754: Road Node 754
  LatLng(29.42909964, 32.40121219), // 755: Road Node 755
  LatLng(29.42900401, 32.40124713), // 756: Road Node 756
  LatLng(29.42892107, 32.40126803), // 757: Road Node 757
  LatLng(29.42875887, 32.40129650), // 758: Road Node 758
  LatLng(29.42868808, 32.40129898), // 759: Road Node 759
  LatLng(29.42863241, 32.40129261), // 760: Road Node 760
  LatLng(29.42854576, 32.40128919), // 761: Spiked Bump 8
  LatLng(29.42849938, 32.40127973), // 762: Road Node 762
];


const Map<String, int> kStationRegistry = {
  'Admission Station': 675,
  'Engineering Station': 616,
  'Arts & Design Station': 600,
  'CS & Eng Station': 557,
  'Pharmacy Station': 527,
  'Nursing Station': 520,
  'Medical Station': 326,
  'Dentistry Station': 460,
  'Physical Therapy Station': 449,
  'Applied Health Station': 441,
  'Science Station': 664,
};

const List<List<int>> kEdgeList = [
  [0, 1],
  [1, 2],
  [2, 3],
  [3, 4],
  [4, 5],
  [5, 6],
  [6, 7],
  [7, 8],
  [8, 9],
  [9, 10],
  [10, 11],
  [11, 12],
  [12, 13],
  [13, 14],
  [14, 15],
  [15, 16],
  [16, 17],
  [17, 18],
  [18, 19],
  [19, 20],
  [20, 21],
  [21, 22],
  [22, 23],
  [23, 24],
  [24, 25],
  [25, 26],
  [26, 27],
  [27, 28],
  [28, 29],
  [29, 30],
  [30, 31],
  [31, 32],
  [32, 33],
  [33, 34],
  [34, 35],
  [35, 36],
  [36, 37],
  [37, 38],
  [38, 39],
  [39, 40],
  [40, 41],
  [41, 42],
  [42, 43],
  [43, 44],
  [44, 45],
  [45, 46],
  [46, 47],
  [47, 48],
  [48, 49],
  [49, 50],
  [50, 51],
  [51, 52],
  [52, 53],
  [53, 54],
  [54, 55],
  [55, 56],
  [56, 57],
  [57, 58],
  [58, 59],
  [59, 60],
  [60, 61],
  [61, 62],
  [62, 63],
  [63, 64],
  [64, 65],
  [65, 66],
  [66, 67],
  [67, 68],
  [68, 69],
  [69, 70],
  [70, 71],
  [71, 72],
  [72, 73],
  [73, 74],
  [74, 75],
  [75, 76],
  [76, 77],
  [77, 78],
  [78, 79],
  [79, 80],
  [80, 81],
  [81, 82],
  [82, 83],
  [83, 84],
  [84, 85],
  [85, 86],
  [85, 97],
  [86, 87],
  [87, 88],
  [88, 89],
  [89, 90],
  [90, 91],
  [91, 92],
  [92, 93],
  [93, 94],
  [94, 95],
  [95, 96],
  [96, 68],
  [96, 586],
  [97, 98],
  [98, 99],
  [99, 100],
  [100, 101],
  [101, 102],
  [102, 103],
  [103, 104],
  [104, 105],
  [105, 106],
  [106, 107],
  [107, 108],
  [108, 109],
  [109, 110],
  [110, 111],
  [111, 112],
  [112, 113],
  [113, 114],
  [114, 115],
  [115, 116],
  [116, 117],
  [117, 118],
  [118, 119],
  [119, 120],
  [119, 121],
  [121, 122],
  [122, 123],
  [123, 124],
  [124, 125],
  [125, 126],
  [126, 127],
  [126, 153],
  [127, 128],
  [128, 129],
  [129, 130],
  [130, 131],
  [131, 132],
  [132, 133],
  [133, 134],
  [134, 135],
  [135, 136],
  [135, 725],
  [136, 137],
  [137, 138],
  [138, 139],
  [139, 140],
  [140, 141],
  [141, 142],
  [142, 143],
  [143, 144],
  [144, 145],
  [145, 146],
  [146, 147],
  [147, 148],
  [148, 149],
  [149, 150],
  [149, 562],
  [150, 151],
  [151, 152],
  [152, 118],
  [153, 154],
  [154, 155],
  [155, 156],
  [156, 157],
  [157, 158],
  [158, 159],
  [159, 160],
  [160, 161],
  [161, 162],
  [162, 163],
  [163, 164],
  [164, 165],
  [165, 166],
  [166, 167],
  [167, 168],
  [168, 169],
  [169, 170],
  [170, 171],
  [171, 172],
  [172, 173],
  [173, 174],
  [174, 175],
  [175, 176],
  [176, 177],
  [177, 178],
  [178, 179],
  [179, 180],
  [180, 181],
  [181, 182],
  [182, 183],
  [183, 184],
  [184, 185],
  [185, 186],
  [186, 187],
  [187, 188],
  [188, 189],
  [189, 190],
  [190, 191],
  [191, 192],
  [192, 193],
  [193, 194],
  [194, 195],
  [195, 196],
  [196, 197],
  [197, 198],
  [198, 199],
  [199, 200],
  [200, 201],
  [201, 202],
  [202, 203],
  [203, 204],
  [203, 222],
  [204, 205],
  [205, 206],
  [206, 207],
  [207, 208],
  [208, 209],
  [209, 210],
  [210, 211],
  [211, 212],
  [212, 213],
  [213, 214],
  [214, 215],
  [214, 705],
  [215, 216],
  [216, 217],
  [217, 218],
  [218, 219],
  [219, 220],
  [220, 221],
  [221, 181],
  [222, 223],
  [223, 224],
  [224, 225],
  [225, 226],
  [226, 227],
  [227, 228],
  [228, 229],
  [229, 230],
  [230, 231],
  [231, 232],
  [232, 233],
  [233, 234],
  [234, 235],
  [235, 236],
  [236, 237],
  [237, 238],
  [238, 239],
  [239, 240],
  [240, 241],
  [241, 242],
  [242, 243],
  [243, 244],
  [244, 245],
  [245, 246],
  [246, 247],
  [247, 248],
  [248, 249],
  [249, 250],
  [250, 251],
  [251, 252],
  [252, 253],
  [253, 254],
  [254, 255],
  [255, 256],
  [256, 257],
  [257, 258],
  [258, 259],
  [258, 284],
  [259, 260],
  [260, 261],
  [261, 262],
  [262, 263],
  [263, 264],
  [264, 265],
  [265, 266],
  [266, 267],
  [267, 268],
  [268, 269],
  [269, 270],
  [270, 271],
  [271, 272],
  [271, 533],
  [272, 273],
  [273, 274],
  [274, 275],
  [275, 276],
  [276, 277],
  [277, 278],
  [278, 279],
  [278, 681],
  [279, 280],
  [280, 281],
  [281, 282],
  [282, 283],
  [283, 252],
  [284, 285],
  [285, 286],
  [286, 287],
  [287, 288],
  [288, 289],
  [289, 290],
  [290, 291],
  [291, 292],
  [292, 293],
  [293, 294],
  [294, 295],
  [295, 296],
  [296, 297],
  [297, 298],
  [298, 299],
  [299, 300],
  [300, 301],
  [301, 302],
  [302, 303],
  [303, 304],
  [304, 305],
  [305, 306],
  [306, 307],
  [307, 308],
  [308, 309],
  [309, 310],
  [310, 311],
  [311, 312],
  [312, 313],
  [313, 314],
  [314, 315],
  [315, 316],
  [316, 317],
  [317, 318],
  [318, 319],
  [319, 320],
  [320, 321],
  [321, 322],
  [321, 336],
  [322, 323],
  [323, 324],
  [324, 325],
  [325, 326],
  [326, 327],
  [327, 328],
  [328, 329],
  [329, 330],
  [330, 331],
  [330, 504],
  [331, 332],
  [332, 333],
  [333, 334],
  [334, 335],
  [335, 304],
  [336, 337],
  [337, 338],
  [338, 339],
  [339, 340],
  [340, 341],
  [341, 342],
  [342, 343],
  [343, 344],
  [344, 345],
  [345, 346],
  [346, 347],
  [347, 348],
  [348, 349],
  [349, 350],
  [350, 351],
  [351, 352],
  [352, 353],
  [353, 354],
  [354, 355],
  [355, 356],
  [356, 357],
  [357, 358],
  [358, 359],
  [359, 360],
  [360, 361],
  [361, 362],
  [362, 363],
  [363, 364],
  [364, 365],
  [365, 366],
  [366, 367],
  [367, 368],
  [368, 369],
  [369, 370],
  [370, 371],
  [371, 372],
  [372, 373],
  [373, 374],
  [374, 375],
  [375, 376],
  [376, 377],
  [377, 378],
  [378, 379],
  [379, 380],
  [380, 381],
  [381, 382],
  [382, 383],
  [383, 384],
  [384, 385],
  [385, 386],
  [386, 387],
  [387, 388],
  [388, 389],
  [389, 390],
  [390, 391],
  [391, 392],
  [392, 393],
  [393, 394],
  [394, 395],
  [395, 396],
  [396, 397],
  [397, 398],
  [398, 399],
  [399, 400],
  [400, 401],
  [401, 402],
  [402, 403],
  [403, 404],
  [404, 405],
  [405, 406],
  [406, 407],
  [407, 408],
  [408, 409],
  [409, 410],
  [410, 411],
  [411, 412],
  [412, 413],
  [413, 414],
  [414, 415],
  [415, 416],
  [416, 417],
  [417, 418],
  [418, 419],
  [419, 420],
  [420, 421],
  [421, 422],
  [422, 423],
  [423, 424],
  [424, 425],
  [425, 426],
  [426, 427],
  [426, 678],
  [427, 428],
  [428, 0],
  [429, 430],
  [430, 431],
  [431, 432],
  [432, 433],
  [433, 434],
  [434, 435],
  [435, 436],
  [436, 437],
  [437, 438],
  [438, 439],
  [439, 440],
  [440, 441],
  [441, 442],
  [442, 443],
  [443, 444],
  [444, 445],
  [445, 446],
  [446, 447],
  [447, 448],
  [448, 449],
  [449, 450],
  [450, 451],
  [451, 452],
  [452, 453],
  [453, 454],
  [454, 455],
  [455, 456],
  [456, 457],
  [457, 458],
  [458, 459],
  [459, 460],
  [460, 461],
  [461, 462],
  [462, 463],
  [463, 464],
  [464, 465],
  [465, 466],
  [466, 467],
  [467, 468],
  [468, 469],
  [469, 470],
  [470, 471],
  [471, 472],
  [472, 473],
  [473, 474],
  [474, 475],
  [475, 476],
  [476, 477],
  [477, 478],
  [478, 479],
  [479, 480],
  [480, 481],
  [481, 482],
  [482, 483],
  [483, 484],
  [484, 485],
  [485, 486],
  [486, 487],
  [487, 488],
  [488, 489],
  [489, 490],
  [490, 491],
  [491, 492],
  [492, 493],
  [493, 494],
  [494, 495],
  [495, 496],
  [496, 497],
  [497, 498],
  [498, 499],
  [499, 500],
  [500, 501],
  [501, 502],
  [502, 503],
  [503, 326],
  [504, 505],
  [505, 506],
  [506, 507],
  [507, 508],
  [508, 509],
  [509, 510],
  [510, 511],
  [511, 512],
  [512, 513],
  [513, 514],
  [514, 515],
  [515, 516],
  [516, 517],
  [517, 518],
  [518, 519],
  [519, 520],
  [520, 521],
  [521, 522],
  [522, 523],
  [523, 524],
  [524, 525],
  [525, 526],
  [526, 527],
  [527, 528],
  [528, 529],
  [529, 530],
  [530, 531],
  [531, 532],
  [532, 265],
  [533, 534],
  [534, 535],
  [535, 536],
  [536, 537],
  [537, 538],
  [538, 539],
  [539, 540],
  [540, 541],
  [541, 542],
  [542, 543],
  [543, 544],
  [544, 545],
  [545, 546],
  [546, 547],
  [547, 548],
  [548, 549],
  [549, 550],
  [550, 551],
  [551, 552],
  [552, 553],
  [553, 554],
  [554, 555],
  [555, 556],
  [556, 557],
  [557, 558],
  [558, 559],
  [559, 560],
  [560, 561],
  [561, 144],
  [562, 563],
  [563, 564],
  [564, 565],
  [565, 566],
  [566, 567],
  [567, 568],
  [568, 569],
  [569, 570],
  [570, 571],
  [571, 572],
  [572, 573],
  [573, 574],
  [574, 575],
  [575, 576],
  [576, 577],
  [577, 578],
  [578, 579],
  [579, 580],
  [580, 581],
  [581, 582],
  [582, 583],
  [583, 584],
  [584, 585],
  [585, 89],
  [586, 587],
  [587, 588],
  [588, 589],
  [589, 590],
  [590, 591],
  [591, 592],
  [592, 593],
  [593, 594],
  [594, 595],
  [595, 596],
  [596, 597],
  [597, 598],
  [598, 599],
  [599, 600],
  [600, 601],
  [601, 602],
  [602, 603],
  [603, 604],
  [604, 605],
  [605, 606],
  [606, 607],
  [607, 608],
  [608, 609],
  [609, 610],
  [610, 611],
  [611, 612],
  [612, 613],
  [613, 614],
  [614, 615],
  [615, 616],
  [616, 617],
  [617, 618],
  [618, 619],
  [619, 620],
  [620, 621],
  [621, 622],
  [622, 623],
  [623, 624],
  [624, 625],
  [625, 626],
  [626, 627],
  [627, 628],
  [628, 629],
  [629, 630],
  [630, 631],
  [631, 632],
  [632, 633],
  [633, 634],
  [634, 635],
  [635, 636],
  [636, 637],
  [637, 638],
  [638, 639],
  [639, 640],
  [640, 641],
  [641, 642],
  [642, 643],
  [643, 644],
  [644, 645],
  [645, 646],
  [646, 647],
  [647, 648],
  [648, 649],
  [649, 650],
  [650, 651],
  [651, 652],
  [652, 653],
  [653, 654],
  [654, 655],
  [655, 656],
  [656, 657],
  [657, 658],
  [658, 659],
  [659, 660],
  [660, 661],
  [661, 662],
  [662, 663],
  [663, 664],
  [664, 665],
  [665, 666],
  [666, 667],
  [667, 668],
  [668, 669],
  [669, 670],
  [670, 671],
  [671, 672],
  [672, 673],
  [673, 674],
  [674, 675],
  [675, 676],
  [676, 677],
  [677, 426],
  [678, 679],
  [679, 680],
  [680, 429],
  [681, 682],
  [682, 683],
  [683, 684],
  [684, 685],
  [685, 686],
  [686, 687],
  [687, 688],
  [688, 689],
  [689, 690],
  [690, 691],
  [691, 692],
  [692, 693],
  [693, 694],
  [694, 695],
  [695, 696],
  [696, 697],
  [697, 698],
  [698, 699],
  [699, 700],
  [700, 701],
  [701, 702],
  [702, 703],
  [703, 704],
  [704, 211],
  [705, 706],
  [706, 707],
  [707, 708],
  [708, 709],
  [709, 710],
  [710, 711],
  [711, 712],
  [712, 713],
  [713, 714],
  [714, 715],
  [715, 716],
  [716, 717],
  [717, 718],
  [718, 719],
  [719, 720],
  [720, 721],
  [721, 722],
  [722, 723],
  [723, 724],
  [724, 132],
  [725, 726],
  [726, 727],
  [727, 728],
  [728, 729],
  [729, 730],
  [730, 731],
  [731, 732],
  [732, 733],
  [733, 734],
  [734, 735],
  [735, 736],
  [736, 737],
  [737, 738],
  [738, 739],
  [739, 740],
  [740, 741],
  [741, 742],
  [742, 743],
  [743, 744],
  [744, 745],
  [745, 746],
  [746, 747],
  [747, 748],
  [748, 749],
  [749, 750],
  [750, 751],
  [751, 752],
  [752, 753],
  [753, 754],
  [754, 755],
  [755, 756],
  [756, 757],
  [757, 758],
  [758, 759],
  [759, 760],
  [760, 761],
  [761, 762],
  [762, 277],
];

double haversineDistance(LatLng p1, LatLng p2) {
  const double R = 6371000;
  double dLat = (p2.latitude - p1.latitude) * math.pi / 180;
  double dLon = (p2.longitude - p1.longitude) * math.pi / 180;
  double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(p1.latitude * math.pi / 180) *
          math.cos(p2.latitude * math.pi / 180) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return R * c;
}

List<LatLng> getRoutePoints(String? startStation, String? endStation) {
  if (startStation == null || endStation == null) return [];
  
  final int? startNode = kStationRegistry[startStation];
  final int? endNode = kStationRegistry[endStation];
  
  if (startNode == null || endNode == null) return [];
  
  final int numNodes = kAllNodes.length;
  final List<double> dist = List.filled(numNodes, double.infinity);
  final List<int> parent = List.filled(numNodes, -1);
  final Set<int> visited = {};
  
  final List<List<int>> adj = List.generate(numNodes, (_) => []);
  for (final edge in kEdgeList) {
    if (edge[0] < numNodes && edge[1] < numNodes) {
      adj[edge[0]].add(edge[1]);
    }
  }
  
  dist[startNode] = 0.0;
  
  while (true) {
    int u = -1;
    double minDist = double.infinity;
    for (int i = 0; i < numNodes; i++) {
      if (!visited.contains(i) && dist[i] < minDist) {
        minDist = dist[i];
        u = i;
      }
    }
    
    if (u == -1 || u == endNode) break;
    visited.add(u);
    
    for (final v in adj[u]) {
      if (!visited.contains(v)) {
        double weight = haversineDistance(kAllNodes[u], kAllNodes[v]);
        double alt = dist[u] + weight;
        if (alt < dist[v]) {
          dist[v] = alt;
          parent[v] = u;
        }
      }
    }
  }
  
  if (dist[endNode] == double.infinity) {
    // Fallback to undirected BFS if directed Dijkstra couldn't find a path
    return _bfsUndirectedFallback(startNode, endNode, adj);
  }
  
  final List<LatLng> route = [];
  int curr = endNode;
  while (curr != -1) {
    route.add(kAllNodes[curr]);
    curr = parent[curr];
  }
  return route.reversed.toList();
}

List<LatLng> _bfsUndirectedFallback(int startNode, int endNode, List<List<int>> directedAdj) {
  final int numNodes = kAllNodes.length;
  final List<List<int>> adj = List.generate(numNodes, (_) => []);
  for (int u = 0; u < numNodes; u++) {
    for (final v in directedAdj[u]) {
      if (u < numNodes && v < numNodes) {
        adj[u].add(v);
        adj[v].add(u);
      }
    }
  }
  
  final List<int> parent = List.filled(numNodes, -1);
  final List<int> queue = [startNode];
  final Set<int> visited = {startNode};
  
  bool found = false;
  while (queue.isNotEmpty) {
    int u = queue.removeAt(0);
    if (u == endNode) {
      found = true;
      break;
    }
    for (final v in adj[u]) {
      if (!visited.contains(v)) {
        visited.add(v);
        parent[v] = u;
        queue.add(v);
      }
    }
  }
  
  if (!found) return [];
  
  final List<LatLng> route = [];
  int curr = endNode;
  while (curr != -1) {
    route.add(kAllNodes[curr]);
    curr = parent[curr];
  }
  return route.reversed.toList();
}


// --- GLOBAL SESSION ---
class AppSession {
  static String email = '';
  static String name = '';
}

// Global state notifier for theme switching
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(true);

class AppThemeColors {
  static Color getBackground(bool isDark) => isDark ? const Color(0xFF0B1326) : const Color(0xFFF8FAFC);
  static Color getSurface(bool isDark) => isDark ? const Color(0xFF171F33) : Colors.white;
  static Color getSurfaceContainerHigh(bool isDark) => isDark ? const Color(0xFF222A3D) : const Color(0xFFF1F5F9);
  static Color getPrimary(bool isDark) => const Color(0xFF10B981); // Emerald Green
  static Color getTextPrimary(bool isDark) => isDark ? const Color(0xFFDAE2FD) : const Color(0xFF0F172A);
  static Color getTextSecondary(bool isDark) => isDark ? const Color(0xFFBBCABF) : const Color(0xFF64748B);
  static Color getBorder(bool isDark) => isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8F0);
  static Color getCardBg(bool isDark) => isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.7);
  static Color getInputBg(bool isDark) => isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9);
}

class StitchColors {
  static const Color surfaceContainerLowest = Color(0xFF060E20);
  static const Color surfaceContainerLow = Color(0xFF131B2E);
  static const Color surfaceContainer = Color(0xFF171F33);
  static const Color surfaceContainerHigh = Color(0xFF222A3D);
  static const Color surfaceContainerHighest = Color(0xFF2D3449);
  static const Color surfaceVariant = Color(0xFF2D3449);
  static const Color primary = Color(0xFF4EDEA3);
  static const Color primaryContainer = Color(0xFF10B981);
  static const Color secondary = Color(0xFFFFB95F);
  static const Color error = Color(0xFFFFB4AB);
  static const Color outlineVariant = Color(0xFF3C4A42);
  static const Color onSurface = Color(0xFFDAE2FD);
  static const Color onSurfaceVariant = Color(0xFFBBCABF);
}

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool hasGlow;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 32,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: StitchColors.primary.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: -10,
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withOpacity(0.6),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(const CampusKartApp());
}

// --- 1. DESIGN SYSTEM & CONSTANTS ---
class AppColors {
  static const primaryNavy = Color(0xFF0B2C4D);
  static const primaryNavyDark = Color(0xFF081F36);
  static const primaryGreen = Color(0xFF2FA36B);
  static const surfaceGray = Color(0xFFF4F6F8);
  static const borderGray = Color(0xFFE2E8F0);
  static const textDark = Color(0xFF1F2933);
  static const textSecondary = Color(0xFF64748B);
  static const accentBlue = Color(0xFF3A6EA5);
  static const destRed = Color(0xFFD64545);
  static const pickupOrange = Color(0xFFF59E0B); // New color for pickup
}

class CampusKartApp extends StatelessWidget {
  const CampusKartApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Outfit',
            brightness: isDark ? Brightness.dark : Brightness.light,
            scaffoldBackgroundColor: AppThemeColors.getBackground(isDark),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

// --- CUSTOM COMPONENTS ---
class GolfCartIcon extends CustomPainter {
  final Color color;
  GolfCartIcon({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.8),
      size.width * 0.1,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.8),
      size.width * 0.1,
      paint,
    );
    canvas.drawRRect(
      RRect.fromLTRBXY(
        size.width * 0.1,
        size.height * 0.65,
        size.width * 0.9,
        size.height * 0.75,
        4,
        4,
      ),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.5,
        size.width * 0.2,
        size.height * 0.15,
      ),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.5,
        size.height * 0.5,
        size.width * 0.2,
        size.height * 0.15,
      ),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.65),
      Offset(size.width * 0.2, size.height * 0.3),
      strokePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.85, size.height * 0.65),
      Offset(size.width * 0.8, size.height * 0.3),
      strokePaint,
    );
    canvas.drawRRect(
      RRect.fromLTRBXY(
        size.width * 0.1,
        size.height * 0.25,
        size.width * 0.9,
        size.height * 0.35,
        8,
        8,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}

class RealCampusMap extends StatelessWidget {
  final LatLng? cartLocation;
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final List<LatLng>? routePoints;
  final bool showAllStations;

  const RealCampusMap({
    super.key,
    this.cartLocation,
    this.pickupLocation,
    this.destinationLocation,
    this.routePoints,
    this.showAllStations = false,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter:
            pickupLocation ??
            cartLocation ??
            const LatLng(29.431068, 32.401685),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.campuskart.app',
        ),
        if (routePoints != null && routePoints!.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints!,
                color: AppColors.primaryGreen.withOpacity(0.7),
                strokeWidth: 5.0,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            // All Stations (if requested)
            if (showAllStations)
              ...kStationCoords.values.map(
                (coord) => Marker(
                  point: coord,
                  width: 30,
                  height: 30,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),

            // Pickup Marker
            if (pickupLocation != null)
              Marker(
                point: pickupLocation!,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.my_location,
                  color: AppColors.pickupOrange,
                  size: 35,
                ),
              ),

            // Destination Marker
            if (destinationLocation != null)
              Marker(
                point: destinationLocation!,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_on,
                  color: AppColors.destRed,
                  size: 35,
                ),
              ),

            // Cart Marker
            if (cartLocation != null)
              Marker(
                point: cartLocation!,
                width: 45,
                height: 45,
                child: const Icon(
                  Icons.electric_car,
                  color: AppColors.primaryNavy,
                  size: 32,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// --- SCREENS ---

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkModeNotifier.value;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF060E20), const Color(0xFF0B1326)]
                : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: CustomPaint(
                size: const Size(80, 80),
                painter: GolfCartIcon(color: const Color(0xFF10B981)),
              ),
            ),
            const SizedBox(height: 28),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                children: const [
                  TextSpan(text: "GUX "),
                  TextSpan(
                    text: "Cart",
                    style: TextStyle(color: Color(0xFF10B981)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "The future of campus mobility",
              style: TextStyle(
                fontFamily: 'Outfit',
                color: isDark ? const Color(0xFFBBCABF) : const Color(0xFF64748B),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- NEW SIGN UP SCREEN ---
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          backgroundColor: AppThemeColors.getBackground(isDark),
          body: Stack(
            children: [
              // Atmospheric Background Effects
              if (isDark) ...[
                Positioned(
                  top: -100,
                  left: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10B981).withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  right: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10B981).withOpacity(0.05),
                    ),
                  ),
                ),
              ],
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CustomPaint(
                            size: const Size(48, 48),
                            painter: GolfCartIcon(color: const Color(0xFF10B981)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            children: const [
                              TextSpan(text: "GUX "),
                              TextSpan(
                                text: "Cart",
                                style: TextStyle(color: Color(0xFF10B981)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Join GUX cart",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            color: AppThemeColors.getTextSecondary(isDark),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Form Card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              padding: const EdgeInsets.all(28.0),
                              decoration: BoxDecoration(
                                color: AppThemeColors.getCardBg(isDark),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: AppThemeColors.getBorder(isDark),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildFieldLabel(isDark, "Full Name"),
                                  _buildInput(
                                    _nameController,
                                    Icons.person_outline,
                                    "Your Name",
                                    isDark,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildFieldLabel(isDark, "Student ID"),
                                  _buildInput(
                                    _idController,
                                    Icons.school_outlined,
                                    "8-digit ID number",
                                    isDark,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildFieldLabel(isDark, "University Email"),
                                  _buildInput(
                                    _emailController,
                                    Icons.mail_outline,
                                    "student@gu.edu.eg",
                                    isDark,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildFieldLabel(isDark, "Password"),
                                  _buildInput(
                                    _passwordController,
                                    Icons.lock_outline,
                                    "••••••••",
                                    isDark,
                                    obscure: _obscureText,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText ? Icons.visibility : Icons.visibility_off,
                                        color: AppThemeColors.getTextSecondary(isDark),
                                      ),
                                      onPressed: () {
                                        setState(() => _obscureText = !_obscureText);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  SizedBox(
                                    height: 54,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF10B981),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        elevation: 4,
                                        shadowColor: const Color(0xFF10B981).withOpacity(0.3),
                                      ),
                                      onPressed: _isLoading ? null : () => _handleSignup(context),
                                      child: _isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : const Text(
                                              "Create Account",
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: AppThemeColors.getTextSecondary(isDark),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (c) => const LoginScreen()),
                              ),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Floating theme toggle in corner
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton.small(
                  backgroundColor: AppThemeColors.getSurface(isDark),
                  foregroundColor: const Color(0xFF10B981),
                  elevation: 2,
                  onPressed: () {
                    isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  },
                  child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSignup(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!email.endsWith('@gu.edu.eg')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email must end with @gu.edu.eg")),
      );
      return;
    }

    final name = _nameController.text.trim();

    setState(() => _isLoading = true);
    String result = await ApiService.signupUser(email, password, name);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created! Please login.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  Widget _buildFieldLabel(bool isDark, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 2.0),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppThemeColors.getTextSecondary(isDark),
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    IconData icon,
    String hint,
    bool isDark, {
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(
        fontFamily: 'Outfit',
        color: AppThemeColors.getTextPrimary(isDark),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppThemeColors.getTextSecondary(isDark)),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Outfit',
          color: isDark ? Colors.white24 : Colors.black26,
        ),
        filled: true,
        fillColor: AppThemeColors.getInputBg(isDark),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppThemeColors.getBorder(isDark)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
        ),
      ),
    );
  }
}

// --- NEW LOGIN SCREEN ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          backgroundColor: AppThemeColors.getBackground(isDark),
          body: Stack(
            children: [
              // Atmospheric Background Effects
              if (isDark) ...[
                Positioned(
                  top: -100,
                  left: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10B981).withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  right: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10B981).withOpacity(0.05),
                    ),
                  ),
                ),
              ],
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CustomPaint(
                            size: const Size(48, 48),
                            painter: GolfCartIcon(color: const Color(0xFF10B981)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            children: const [
                              TextSpan(text: "GUX "),
                              TextSpan(
                                text: "Cart",
                                style: TextStyle(color: Color(0xFF10B981)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "The future of campus mobility. Fast and autonomous.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            color: AppThemeColors.getTextSecondary(isDark),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Form Card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              padding: const EdgeInsets.all(28.0),
                              decoration: BoxDecoration(
                                color: AppThemeColors.getCardBg(isDark),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: AppThemeColors.getBorder(isDark),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildFieldLabel(isDark, "University Email"),
                                  _buildInput(
                                    _emailController,
                                    Icons.mail_outline,
                                    "student@university.edu",
                                    isDark,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildFieldLabel(isDark, "Password"),
                                  _buildInput(
                                    _passwordController,
                                    Icons.lock_outline,
                                    "••••••••",
                                    isDark,
                                    obscure: _obscureText,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText ? Icons.visibility : Icons.visibility_off,
                                        color: AppThemeColors.getTextSecondary(isDark),
                                      ),
                                      onPressed: () {
                                        setState(() => _obscureText = !_obscureText);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  SizedBox(
                                    height: 54,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF10B981),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        elevation: 4,
                                        shadowColor: const Color(0xFF10B981).withOpacity(0.3),
                                      ),
                                      onPressed: _isLoading ? null : () => _handleLogin(context),
                                      child: _isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : const Text(
                                              "Sign In",
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New to campus? ",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: AppThemeColors.getTextSecondary(isDark),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (c) => const SignUpScreen()),
                              ),
                              child: const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Floating theme toggle in corner
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton.small(
                  backgroundColor: AppThemeColors.getSurface(isDark),
                  foregroundColor: const Color(0xFF10B981),
                  elevation: 2,
                  onPressed: () {
                    isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  },
                  child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLogin(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => _isLoading = true);
    String result = await ApiService.loginUser(email, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result == "AdminSuccess") {
      AppSession.email = email;
      AppSession.name = 'Admin';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const AdminScreen()),
      );
    } else if (result.startsWith("Success:")) {
      AppSession.email = email;
      AppSession.name = result.substring(8); // extract name after "Success:"
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const HomeMapScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  Widget _buildFieldLabel(bool isDark, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 2.0),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppThemeColors.getTextSecondary(isDark),
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    IconData icon,
    String hint,
    bool isDark, {
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(
        fontFamily: 'Outfit',
        color: AppThemeColors.getTextPrimary(isDark),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppThemeColors.getTextSecondary(isDark)),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Outfit',
          color: isDark ? Colors.white24 : Colors.black26,
        ),
        filled: true,
        fillColor: AppThemeColors.getInputBg(isDark),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppThemeColors.getBorder(isDark)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
        ),
      ),
    );
  }
}

class HomeMapScreen extends StatelessWidget {
  const HomeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          backgroundColor: AppThemeColors.getBackground(isDark),
          body: Stack(
            children: [
              const Positioned.fill(child: RealCampusMap()),
              Center(child: _PulseMarker()),
              const Positioned(
                top: 200,
                left: 100,
                child: Icon(
                  Icons.location_on,
                  color: Color(0xFF10B981),
                  size: 32,
                ),
              ),
              const Positioned(
                bottom: 300,
                right: 80,
                child: Icon(
                  Icons.location_on,
                  color: Color(0xFF10B981),
                  size: 32,
                ),
              ),
              // Top Navigation / Header row
              Positioned(
                top: 60,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    _circleIcon(
                      Icons.menu,
                      isDark,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) => const SettingsScreen()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const SelectPickupScreen(),
                          ),
                        ),
                        child: _searchBar(isDark),
                      ),
                    ),
                  ],
                ),
              ),
              // Floating theme toggle on right
              Positioned(
                top: 130,
                right: 20,
                child: FloatingActionButton.small(
                  heroTag: 'homeThemeToggle',
                  backgroundColor: AppThemeColors.getSurface(isDark),
                  foregroundColor: const Color(0xFF10B981),
                  elevation: 4,
                  onPressed: () {
                    isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  },
                  child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),
              // Bottom sheet panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppThemeColors.getSurface(isDark),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black38 : Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      )
                    ],
                    border: Border(
                      top: BorderSide(color: AppThemeColors.getBorder(isDark)),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Available Rides",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppThemeColors.getTextPrimary(isDark),
                            ),
                          ),
                          const Text(
                            "8 carts nearby",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor: const Color(0xFF10B981).withOpacity(0.3),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => const SelectPickupScreen(),
                            ),
                          ),
                          child: const Text(
                            "REQUEST A RIDE",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _circleIcon(IconData icon, bool isDark, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppThemeColors.getSurface(isDark),
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
          border: Border.all(color: AppThemeColors.getBorder(isDark)),
        ),
        child: Icon(icon, color: const Color(0xFF10B981)),
      ),
    );
  }

  Widget _searchBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppThemeColors.getSurface(isDark),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        border: Border.all(color: AppThemeColors.getBorder(isDark)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppThemeColors.getTextSecondary(isDark)),
          const SizedBox(width: 10),
          Text(
            "Where to?",
            style: TextStyle(
              fontFamily: 'Outfit',
              color: AppThemeColors.getTextSecondary(isDark),
            ),
          ),
        ],
      ),
    );
  }
}

// 1. SELECT PICKUP SCREEN
class SelectPickupScreen extends StatelessWidget {
  const SelectPickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = kStationNames;

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          backgroundColor: AppThemeColors.getBackground(isDark),
          appBar: AppBar(
            backgroundColor: AppThemeColors.getSurface(isDark),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppThemeColors.getTextPrimary(isDark)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Select Pickup Station",
              style: TextStyle(
                fontFamily: 'Outfit',
                color: AppThemeColors.getTextPrimary(isDark),
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(color: AppThemeColors.getBorder(isDark), height: 1.0),
            ),
          ),
          body: Column(
            children: [
              const Expanded(flex: 2, child: RealCampusMap(showAllStations: true)),
              Expanded(
                flex: 3,
                child: Container(
                  color: AppThemeColors.getSurface(isDark),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: locations.length,
                    separatorBuilder: (c, i) => Divider(color: AppThemeColors.getBorder(isDark)),
                    itemBuilder: (c, i) {
                      final stationName = locations[i];
                      return ListTile(
                        leading: const Icon(
                          Icons.my_location,
                          color: AppColors.pickupOrange,
                        ),
                        title: Text(
                          stationName,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                            color: AppThemeColors.getTextPrimary(isDark),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppThemeColors.getTextSecondary(isDark),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => SelectDestinationScreen(pickupName: stationName),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 2. SELECT DESTINATION SCREEN
class SelectDestinationScreen extends StatefulWidget {
  final String pickupName;
  const SelectDestinationScreen({super.key, required this.pickupName});

  @override
  State<SelectDestinationScreen> createState() => _SelectDestinationScreenState();
}

class _SelectDestinationScreenState extends State<SelectDestinationScreen> {
  String? _previewDest;

  @override
  Widget build(BuildContext context) {
    final locations = kStationNames;

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          backgroundColor: AppThemeColors.getBackground(isDark),
          appBar: AppBar(
            backgroundColor: AppThemeColors.getSurface(isDark),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppThemeColors.getTextPrimary(isDark)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Choose Destination",
              style: TextStyle(
                fontFamily: 'Outfit',
                color: AppThemeColors.getTextPrimary(isDark),
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(color: AppThemeColors.getBorder(isDark), height: 1.0),
            ),
          ),
          body: Column(
            children: [
              Container(
                color: AppThemeColors.getSurfaceContainerHigh(isDark),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.my_location,
                      color: AppColors.pickupOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Pickup: ${widget.pickupName}",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        color: AppThemeColors.getTextSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: RealCampusMap(
                  pickupLocation: kStationCoords[widget.pickupName],
                  destinationLocation: _previewDest != null ? kStationCoords[_previewDest] : null,
                  routePoints: _previewDest != null ? getRoutePoints(widget.pickupName, _previewDest) : [],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: AppThemeColors.getSurface(isDark),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: locations.length,
                    separatorBuilder: (c, i) => Divider(color: AppThemeColors.getBorder(isDark)),
                    itemBuilder: (c, i) {
                      final destName = locations[i];
                      if (destName == widget.pickupName) return const SizedBox.shrink();

                      final isSelected = _previewDest == destName;

                      return ListTile(
                        selected: isSelected,
                        selectedTileColor: const Color(0xFF10B981).withOpacity(0.05),
                        leading: Icon(
                          Icons.location_on,
                          color: isSelected ? const Color(0xFF10B981) : AppColors.destRed,
                        ),
                        title: Text(
                          destName,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF10B981)
                                : AppThemeColors.getTextPrimary(isDark),
                          ),
                        ),
                        trailing: isSelected
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => RequestConfirmScreen(
                                        pickupName: widget.pickupName,
                                        destName: destName,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "GO",
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: AppThemeColors.getTextSecondary(isDark),
                              ),
                        onTap: () {
                          setState(() => _previewDest = destName);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 3. CONFIRM SCREEN (Updated)
class RequestConfirmScreen extends StatefulWidget {
  final String pickupName;
  final String destName;

  const RequestConfirmScreen({
    super.key,
    required this.pickupName,
    required this.destName,
  });

  @override
  State<RequestConfirmScreen> createState() => _RequestConfirmScreenState();
}

class _RequestConfirmScreenState extends State<RequestConfirmScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          backgroundColor: AppThemeColors.getBackground(isDark),
          body: Stack(
            children: [
              Positioned.fill(
                child: RealCampusMap(
                  pickupLocation: kStationCoords[widget.pickupName],
                  destinationLocation: kStationCoords[widget.destName],
                  routePoints: getRoutePoints(widget.pickupName, widget.destName),
                ),
              ),
              // Floating theme toggle on right
              Positioned(
                top: 96,
                right: 20,
                child: FloatingActionButton.small(
                  heroTag: 'confirmThemeToggle',
                  backgroundColor: AppThemeColors.getSurface(isDark),
                  foregroundColor: const Color(0xFF10B981),
                  elevation: 4,
                  onPressed: () {
                    isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  },
                  child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),
              // Bottom sheet panel containing route & vehicle confirmation
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppThemeColors.getSurface(isDark),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black38 : Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      )
                    ],
                    border: Border(
                      top: BorderSide(color: AppThemeColors.getBorder(isDark)),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Grabber
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white24 : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        "Confirm Your Ride",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppThemeColors.getTextPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Station Timeline
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.pickupOrange,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppThemeColors.getBorder(isDark),
                                ),
                              ),
                              Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.destRed,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "PICKUP",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColors.getTextSecondary(isDark),
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    Text(
                                      widget.pickupName,
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColors.getTextPrimary(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "DROPOFF",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColors.getTextSecondary(isDark),
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    Text(
                                      widget.destName,
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColors.getTextPrimary(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Divider(color: AppThemeColors.getBorder(isDark)),
                      const SizedBox(height: 16),

                      // Vehicle Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF10B981).withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppThemeColors.getSurface(isDark),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.electric_car_outlined,
                                color: Color(0xFF10B981),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "CK-003",
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppThemeColors.getTextPrimary(isDark),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "FREE",
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Autonomous Pod • 4 Seats",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 13,
                                      color: AppThemeColors.getTextSecondary(isDark),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // CTA Confirm request button
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor: const Color(0xFF10B981).withOpacity(0.3),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() => _isLoading = true);

                                  String? rideId = await ApiService.sendRideRequest(
                                    AppSession.email,
                                    widget.pickupName,
                                    widget.destName,
                                  );
                                  if (!mounted) return;

                                  setState(() => _isLoading = false);

                                  if (rideId != null) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) => ActiveRideScreen(
                                          rideId: rideId,
                                          dest: widget.destName,
                                          pickup: widget.pickupName,
                                        ),
                                      ),
                                      (r) => false,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Unable to connect to server."),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "CONFIRM REQUEST",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, color: Colors.white),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Remaining screens (OnWay, InProgress, etc.) remain mostly the same ---

class ActiveRideScreen extends StatefulWidget {
  final String rideId;
  final String dest;
  final String pickup; // Added pickup name
  const ActiveRideScreen({
    super.key,
    required this.rideId,
    required this.dest,
    required this.pickup,
  });
  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  Timer? _timer;
  String _status = "pending";
  String _eta = "0s";
  double _distance = 0.0;
  LatLng? _cartLocation;
  bool _isObcOffline = false;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _fetchStatus());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _canCancel() {
    return _status == 'pending' ||
        _status == 'confirmed' ||
        _status == 'en_route_to_pickup' ||
        _status == 'arrived_at_pickup';
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: AppThemeColors.getSurface(isDarkModeNotifier.value),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Cancel Ride",
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            color: AppThemeColors.getTextPrimary(isDarkModeNotifier.value),
          ),
        ),
        content: Text(
          "Are you sure you want to cancel this ride request?",
          style: TextStyle(
            fontFamily: 'Outfit',
            color: AppThemeColors.getTextSecondary(isDarkModeNotifier.value),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text(
              "No, Keep",
              style: TextStyle(fontFamily: 'Outfit', color: Color(0xFF10B981)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(c);
              _cancelRide();
            },
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelRide() async {
    final success = await ApiService.cancelRide(widget.rideId);
    if (success) {
      _fetchStatus();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to cancel ride. Please try again.")),
        );
      }
    }
  }

  Future<void> _fetchStatus() async {
    final data = await ApiService.getRide(widget.rideId);
    if (data != null && mounted) {
      setState(() {
        _status = data['status'] ?? 'pending';
        _eta = data['eta_min']?.toString() ?? "0s";
        _distance = (data['distance_m'] ?? 0.0).toDouble();

        if (data['live_cart_lat'] != null && data['live_cart_lon'] != null) {
          _cartLocation = LatLng(
            data['live_cart_lat'].toDouble(),
            data['live_cart_lon'].toDouble(),
          );
        }

        // Check if the On-Board Computer heartbeat is stale
        final String? updatedAtStr = data['updatedAt'];
        if (updatedAtStr != null && _status != 'completed' && _status != 'cancelled' && _status != 'pending') {
          try {
            final DateTime updatedAt = DateTime.parse(updatedAtStr).toUtc();
            final DateTime now = DateTime.now().toUtc();
            final difference = now.difference(updatedAt).inSeconds;
            // 8 seconds threshold as requested
            _isObcOffline = difference > 8;
          } catch (e) {
            _isObcOffline = false;
          }
        } else {
          _isObcOffline = false;
        }
      });

      if (_status == 'completed') {
        _timer?.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => RideCompletedScreen(rideId: widget.rideId),
          ),
        );
      } else if (_status == 'cancelled') {
        _timer?.cancel();
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            backgroundColor: AppThemeColors.getSurface(isDarkModeNotifier.value),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(
              "Ride Cancelled",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.bold,
                color: AppThemeColors.getTextPrimary(isDarkModeNotifier.value),
              ),
            ),
            content: Text(
              "Sorry, this trip could not be completed. Please try choosing a different station.",
              style: TextStyle(
                fontFamily: 'Outfit',
                color: AppThemeColors.getTextSecondary(isDarkModeNotifier.value),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(c);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeMapScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "OK",
                  style: TextStyle(fontFamily: 'Outfit', color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  String getStatusText() {
    switch (_status) {
      case "pending":
        return "Looking for a cart... You are in the queue.";
      case "confirmed":
        return "Trip Confirmed! Cart is on the way.";
      case "en_route_to_pickup":
        return "Cart is on its way to your pickup.";
      case "arrived_at_pickup":
        return "Your cart has arrived! Please board.";
      case "en_route_to_dropoff":
        return "Heading to destination.";
      default:
        return "Processing...";
    }
  }

  String formatDisplayEta(String eta) {
    if (eta.isEmpty) return "1 min";
    
    String clean = eta.trim().toLowerCase();
    
    if (clean.contains('min')) {
      clean = clean.replaceAll('min', '').trim();
    }
    
    if (clean.contains('m')) {
      final parts = clean.split('m');
      final minutesStr = parts[0].trim();
      double? minsDouble = double.tryParse(minutesStr);
      if (minsDouble != null) {
        int mins = minsDouble.toInt();
        if (mins <= 0) mins = 1;
        return "$mins min";
      }
    }
    
    if (clean.endsWith('s')) {
      final secsStr = clean.replaceAll('s', '').trim();
      double? secs = double.tryParse(secsStr);
      if (secs != null) {
        return "1 min";
      }
    }
    
    double? val = double.tryParse(clean);
    if (val != null) {
      int mins = val.toInt();
      if (mins <= 0) mins = 1;
      return "$mins min";
    }
    
    return eta;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          backgroundColor: AppThemeColors.getBackground(isDark),
          body: Stack(
            children: [
              Positioned.fill(
                child: RealCampusMap(
                  cartLocation: _cartLocation,
                  pickupLocation: kStationCoords[widget.pickup],
                  destinationLocation: kStationCoords[widget.dest],
                  routePoints: getRoutePoints(widget.pickup, widget.dest),
                ),
              ),
              // Floating theme toggle on right
              Positioned(
                top: 96,
                right: 20,
                child: FloatingActionButton.small(
                  heroTag: 'trackingThemeToggle',
                  backgroundColor: AppThemeColors.getSurface(isDark),
                  foregroundColor: const Color(0xFF10B981),
                  elevation: 4,
                  onPressed: () {
                    isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  },
                  child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),
              // Bottom status card sheet
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppThemeColors.getSurface(isDark),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black38 : Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      )
                    ],
                    border: Border(
                      top: BorderSide(color: AppThemeColors.getBorder(isDark)),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Grabber
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white24 : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Status Header
                      Text(
                        getStatusText(),
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppThemeColors.getTextPrimary(isDark),
                        ),
                      ),
                      Text(
                        _status == 'pending'
                            ? "Please wait in the queue..."
                            : "Sit back and relax.",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          color: AppThemeColors.getTextSecondary(isDark),
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_status == 'pending') ...[
                        const SizedBox(height: 20),
                        const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ] else ...[
                        // Live Metrics Grid
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppThemeColors.getBorder(isDark)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ARRIVAL INFO",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColors.getTextSecondary(isDark),
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Arriving in ${formatDisplayEta(_eta)}",
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppThemeColors.getBorder(isDark)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "DISTANCE",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColors.getTextSecondary(isDark),
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${_distance.toStringAsFixed(0)} m",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColors.getTextPrimary(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Progress Bar Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.pickup,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                color: AppThemeColors.getTextSecondary(isDark),
                              ),
                            ),
                            Text(
                              widget.dest,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                color: AppThemeColors.getTextSecondary(isDark),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            color: const Color(0xFF10B981),
                            backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Pilot info & Cancel Button
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppThemeColors.getBorder(isDark)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.smart_toy_outlined,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Auto-Pilot Active",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppThemeColors.getTextPrimary(isDark),
                                    ),
                                  ),
                                  Text(
                                    "Safety systems nominal",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 12,
                                      color: AppThemeColors.getTextSecondary(isDark),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (_canCancel()) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              side: const BorderSide(color: Colors.redAccent, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => _confirmCancel(context),
                            child: const Text(
                              "Cancel Ride",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // OBC Connection Lost Alert Overlay
              if (_isObcOffline)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: Card(
                          color: AppThemeColors.getSurface(isDark),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: AppThemeColors.getBorder(isDark)),
                          ),
                          elevation: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: 64,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Connection Lost",
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppThemeColors.getTextPrimary(isDark),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "The cart's on-board computer went offline mid-trip. It may have experienced a power failure or an emergency stop. Please wait or proceed safely to your destination.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 14,
                                    color: AppThemeColors.getTextSecondary(isDark),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: () {
                                      _timer?.cancel();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (c) => const HomeMapScreen()),
                                        (r) => false,
                                      );
                                    },
                                    child: const Text(
                                      "Return to Home",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class RideCompletedScreen extends StatefulWidget {
  final String rideId;
  const RideCompletedScreen({super.key, required this.rideId});

  @override
  State<RideCompletedScreen> createState() => _RideCompletedScreenState();
}

class _RideCompletedScreenState extends State<RideCompletedScreen> {
  int _selectedRating = 0;
  bool _isSubmitting = false;
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a star rating first."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final feedbackText = _feedbackController.text.trim();
    final success = await ApiService.rateRide(
      widget.rideId,
      _selectedRating,
      feedbackText,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? "Feedback submitted! Thank you." : "Failed to send feedback.",
          ),
          backgroundColor: success ? const Color(0xFF10B981) : Colors.red,
        ),
      );
      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => const HomeMapScreen()),
          (r) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return "Poor";
      case 2:
        return "Fair";
      case 3:
        return "Good";
      case 4:
        return "Great";
      case 5:
        return "Excellent";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          backgroundColor: AppThemeColors.getBackground(isDark),
          body: Stack(
            children: [
              // Atmospheric Background Effects
              if (isDark) ...[
                Positioned(
                  top: -100,
                  right: -100,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10B981).withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  left: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFB95F).withOpacity(0.05),
                    ),
                  ),
                ),
              ],
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Glassmorphic Panel
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              padding: const EdgeInsets.all(28.0),
                              decoration: BoxDecoration(
                                color: AppThemeColors.getCardBg(isDark),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: AppThemeColors.getBorder(isDark),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Ride Completion Summary Logo & Title
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: CustomPaint(
                                          size: const Size(48, 48),
                                          painter: GolfCartIcon(color: const Color(0xFF10B981)),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Ride Completed!",
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppThemeColors.getTextPrimary(isDark),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "How was your experience?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 14,
                                          color: AppThemeColors.getTextSecondary(isDark),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 28),

                                  // Star Rating Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      final starValue = index + 1;
                                      final isActive = starValue <= _selectedRating;
                                      return IconButton(
                                        iconSize: 42,
                                        icon: Icon(
                                          isActive ? Icons.star : Icons.star_border_outlined,
                                          color: isActive ? const Color(0xFFFFB95F) : AppThemeColors.getTextSecondary(isDark),
                                        ),
                                        onPressed: _isSubmitting
                                            ? null
                                            : () {
                                                setState(() => _selectedRating = starValue);
                                              },
                                      );
                                    }),
                                  ),
                                  if (_selectedRating > 0) ...[
                                    const SizedBox(height: 4),
                                    Center(
                                      child: Text(
                                        _getRatingLabel(_selectedRating),
                                        style: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFB95F),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 24),

                                  // Feedback Text Input
                                  Text(
                                    "Share more details (Optional)",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppThemeColors.getTextSecondary(isDark),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _feedbackController,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: AppThemeColors.getTextPrimary(isDark),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Tell us more about your experience...",
                                      hintStyle: TextStyle(
                                        fontFamily: 'Outfit',
                                        color: isDark ? Colors.white24 : Colors.black26,
                                      ),
                                      filled: true,
                                      fillColor: AppThemeColors.getInputBg(isDark),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: AppThemeColors.getBorder(isDark)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Submit Action Button
                                  SizedBox(
                                    height: 52,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF10B981),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        elevation: 4,
                                        shadowColor: const Color(0xFF10B981).withOpacity(0.3),
                                      ),
                                      onPressed: _isSubmitting ? null : _submitFeedback,
                                      child: _isSubmitting
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : const Text(
                                              "Submit Feedback",
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Receipt Details summary row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Duration: 8 min",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: AppThemeColors.getTextSecondary(isDark),
                                    ),
                                  ),
                                  Text(
                                    "Distance: 1.2 miles",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: AppThemeColors.getTextSecondary(isDark),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(color: AppThemeColors.getBorder(isDark)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Total Points Earned",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                  Text(
                                    "+24 pts",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Skip text action
                        TextButton(
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (c) => const HomeMapScreen()),
                            (r) => false,
                          ),
                          child: Text(
                            "Skip & book another ride",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: AppThemeColors.getTextSecondary(isDark),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Floating theme toggle on right top
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton.small(
                  heroTag: 'feedbackThemeToggle',
                  backgroundColor: AppThemeColors.getSurface(isDark),
                  foregroundColor: const Color(0xFF10B981),
                  elevation: 2,
                  onPressed: () {
                    isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  },
                  child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryNavy,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryNavy,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                AppSession.name.isNotEmpty
                    ? AppSession.name
                    : AppSession.email.split('@')[0],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                AppSession.email.isNotEmpty
                    ? AppSession.email
                    : 'Not logged in',
              ),
              trailing: const Icon(Icons.edit, size: 20),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Preferences",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          _settingTile(Icons.notifications, "Notifications"),
          _settingTile(Icons.location_on, "Saved Locations"),
          _settingTile(Icons.history, "Ride History"),
          const Divider(),
          _settingTile(Icons.help, "Help & Support"),
          _settingTile(Icons.info, "About GUX cart"),
          const SizedBox(height: 40),
          OutlinedButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (c) => const LoginScreen()),
              (r) => false,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.all(16),
            ),
            child: const Text("LOG OUT"),
          ),
        ],
      ),
    );
  }

  Widget _settingTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryNavy),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    );
  }
}

class _PulseMarker extends StatefulWidget {
  @override
  State<_PulseMarker> createState() => _PulseMarkerState();
}

class _PulseMarkerState extends State<_PulseMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.3).animate(_ctrl),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: AppColors.accentBlue.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.accentBlue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// --- ADMIN PORTAL ---

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0; 
  Map<String, dynamic> _rideAnalytics = {};
  Map<String, dynamic> _stationAnalytics = {};
  Map<String, dynamic> _telemetry = {};
  bool _loading = true;
  Timer? _telemetryTimer;
  bool _pulseState = false;
  Timer? _pulseTimer;

  // Manual Override State
  bool _estopActive = false;
  String _mode = 'auto';
  String _manualCommand = 'stop';
  double _manualThrottle = 0.0;
  Timer? _throttleTimer;
  DateTime _lastControlSend = DateTime.now();
  @override
  void initState() {
    super.initState();
    _loadAllData();
    _telemetryTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _loadTelemetry(),
    );
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (mounted) setState(() => _pulseState = !_pulseState);
    });
  }

  @override
  void dispose() {
    _telemetryTimer?.cancel();
    _pulseTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    final rideData = await ApiService.getRideAnalytics();
    final stationData = await ApiService.getStationAnalytics();
    final telemetryData = await ApiService.getLatestTelemetry();
    final adminControlData = await ApiService.getAdminControl();
    if (mounted) {
      setState(() {
        _rideAnalytics = rideData;
        _stationAnalytics = stationData;
        _telemetry = telemetryData;
        if (adminControlData.containsKey('admin_control')) {
          final ac = adminControlData['admin_control'];
          _estopActive = ac['estop'] ?? false;
          _mode = ac['mode'] ?? 'auto';
          _manualCommand = ac['manual_command'] ?? 'stop';
          _manualThrottle = (ac['manual_throttle'] ?? 0).toDouble();
        }
        _loading = false;
      });
    }
  }

  Future<void> _loadTelemetry() async {
    final telemetryData = await ApiService.getLatestTelemetry();
    if (mounted) {
      setState(() {
        _telemetry = telemetryData;
      });
    }
  }

  List<Map<String, dynamic>> _getGlobalAlerts() {
    final List<Map<String, dynamic>> alerts = [];
    final now = DateTime.now();

    _telemetry.forEach((cartId, data) {
      // 1. Offline Alert (last seen check)
      final lastSeenStr = data['last_seen'];
      if (lastSeenStr != null) {
        final lastSeen = DateTime.parse(lastSeenStr);
        if (now.difference(lastSeen).inSeconds > 15) {
          alerts.add({
            "cart_id": cartId,
            "type": "Offline",
            "message": "Cart telemetry link lost (offline for >15s)",
            "time": lastSeen.toLocal().toString().split(' ')[1].substring(0, 5),
          });
        }
      }

      // 2. Low Battery Alert (<20%)
      final double battery = (data['battery_pct'] ?? 100.0).toDouble();
      if (battery < 20.0) {
        alerts.add({
          "cart_id": cartId,
          "type": "Battery Critical",
          "message": "Critical low battery SoC: ${battery.toStringAsFixed(1)}%",
          "time": now.toString().split(' ')[1].substring(0, 5),
        });
      }

      // 3. Motor Error
      if (data['motor_status'] == 0) {
        alerts.add({
          "cart_id": cartId,
          "type": "Motor Fault",
          "message": "Drive motor controller reported fault code",
          "time": now.toString().split(' ')[1].substring(0, 5),
        });
      }

      // 4. PLC Error
      if (data['plc_status'] == 0) {
        alerts.add({
          "cart_id": cartId,
          "type": "PLC Timeout",
          "message": "Programmable logic controller ping timeout",
          "time": now.toString().split(' ')[1].substring(0, 5),
        });
      }

      // 5. Sensor & Hardware Faults
      final sensors = {
        'ESP32': data['esp_status'],
        'Left Ultra-Sonic': data['left_ultrasonic'],
        'Right Ultra-Sonic': data['right_ultrasonic'],
        'Rear Ultra-Sonic': data['rear_ultrasonic'],
        'LiDAR': data['lidar_status'],
        'IMU': data['imu_status'],
        'GPS': data['gps_status'],
        'Optical Encoder': data['encoder_status'],
        '24V Rail': data['rail_24v_status'],
        '5V Rail': data['rail_5v_status'],
        'ACS-712': data['acs712_status'],
      };

      sensors.forEach((name, status) {
        if (status == 0) {
          alerts.add({
            "cart_id": cartId,
            "type": "Hardware Fault",
            "message": "$name reported failure or disconnect",
            "time": now.toString().split(' ')[1].substring(0, 5),
          });
        }
      });
    });

    return alerts;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: StitchColors.surfaceContainerLowest,
        body: Center(
          child: CircularProgressIndicator(color: StitchColors.primary),
        ),
      );
    }

    final alerts = _getGlobalAlerts();

    return Scaffold(
      backgroundColor: StitchColors.surfaceContainerLowest,
      body: Stack(
        children: [
          // Background Ambient Animation (simplified static glow circles)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: StitchColors.primary.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(color: StitchColors.primary.withOpacity(0.05), blurRadius: 120),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: StitchColors.secondary.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(color: StitchColors.secondary.withOpacity(0.05), blurRadius: 120),
                ],
              ),
            ),
          ),
          
          Row(
            children: [
              // --- SIDEBAR (Stitch Layout) ---
              Container(
                width: 256,
                decoration: const BoxDecoration(
                  color: StitchColors.surfaceContainerLowest,
                  border: Border(right: BorderSide(color: Colors.white10)),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        "GUX cart",
                        style: TextStyle(
                          color: StitchColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildNavItem(Icons.dashboard_rounded, "Ride & Trip Analytics", 0),
                          _buildNavItem(Icons.map_rounded, "Station Analytics", 1),
                          _buildNavItem(Icons.battery_charging_full_rounded, "Vehicle Health & Power", 2),
                          _buildNavItem(Icons.developer_board_rounded, "Control OBC (Payload)", 3),
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 16),
                          _buildNavItem(Icons.electric_car_rounded, "Manage Vehicles", 4),
                          _buildNavItem(Icons.alt_route_rounded, "Manage Rides", 5),
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 16),
                          _buildNavItem(Icons.gamepad_rounded, "Manual Override", 6),
                        ],
                      ),
                    ),
                    // Bottom Admin Profile Area
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.white10)),
                      ),
                      child: GlassPanel(
                        padding: const EdgeInsets.all(12),
                        borderRadius: 16,
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: StitchColors.primary.withOpacity(0.3)),
                                image: const DecorationImage(
                                  image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuC1Gxr1RfTtXEd0Ic_L9Skd_VJCv4cTeVKb5oo2Wc1muDVivKkUXOr5m7BHSg20Q-DzhyplJnhCovLtaoK-0bC6Bm29gib4OImxHbzBgK9-I8zuvwnZD3DdtMGDOLnjOC28qza9l7RdpJKH2WbEPhL45HLdAHP8HG0rmTa_5-Lhx4R8AYDF6Ic9qHY1H65yj79_22L6cVGUc9jtr19jGYHWpI-tZQ_gF-xmnaL4IxsrJsKZ9NX2ISrVN4fXr7NlMq5UIvZJK7JZvo4"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Admin Root", style: TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text("Fleet Supervisor", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // --- MAIN CONTENT AREA ---
              Expanded(
                child: Column(
                  children: [
                    // Top Header Bar
                    GlassPanel(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                      borderRadius: 0,
                      child: SizedBox(
                        height: 64,
                        child: Row(
                          children: [
                            const Text(
                              "Fleet Command Dashboard",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: StitchColors.onSurface),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.search, color: StitchColors.onSurfaceVariant),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications, color: StitchColors.onSurfaceVariant),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            Container(width: 1, height: 24, color: Colors.white10),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: StitchColors.primary.withOpacity(0.1),
                                border: Border.all(color: StitchColors.primary.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  AnimatedOpacity(
                                    opacity: _pulseState ? 1.0 : 0.3,
                                    duration: const Duration(milliseconds: 500),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: StitchColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text("System Live", style: TextStyle(color: StitchColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: StitchColors.onSurfaceVariant),
                              onPressed: _loadAllData,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- GLOBAL CRITICAL ALERTS PANEL ---
                    Padding(
                      padding: const EdgeInsets.only(top: 24, left: 32, right: 32),
                      child: alerts.isNotEmpty
                          ? AnimatedOpacity(
                              opacity: _pulseState ? 1.0 : 0.7,
                              duration: const Duration(milliseconds: 800),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: StitchColors.error.withOpacity(0.1),
                                  border: Border.all(color: StitchColors.error.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(color: StitchColors.error.withOpacity(0.2), shape: BoxShape.circle),
                                          child: const Icon(Icons.warning_rounded, color: StitchColors.error, size: 24),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          "GLOBAL CRITICAL ALERTS DETECTED",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: StitchColors.error),
                                        ),
                                        const Spacer(),
                                        Text("${alerts.length} faults", style: const TextStyle(fontWeight: FontWeight.bold, color: StitchColors.error)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ...alerts.map(
                                      (alert) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.circle, color: StitchColors.error, size: 6),
                                            const SizedBox(width: 8),
                                            Text("[${alert['cart_id']}] ", style: const TextStyle(fontWeight: FontWeight.bold, color: StitchColors.onSurface)),
                                            Text("${alert['type']}: ", style: const TextStyle(fontWeight: FontWeight.bold, color: StitchColors.error)),
                                            Expanded(child: Text(alert['message'], style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 13))),
                                            Text(alert['time'], style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: StitchColors.primary.withOpacity(0.1),
                                border: Border.all(color: StitchColors.primary.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: StitchColors.primary.withOpacity(0.2), shape: BoxShape.circle),
                                    child: const Icon(Icons.check_circle, color: StitchColors.primary, size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("All shuttle systems online", style: TextStyle(fontWeight: FontWeight.bold, color: StitchColors.primary)),
                                      Text("Fleet status: Active. No hardware faults reported across campus zones.", style: TextStyle(color: StitchColors.primary.withOpacity(0.8), fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    ),

                    // MAIN CONTENT SWITCHER
                    Expanded(
                      child: _buildCurrentScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0: return _buildRideAnalyticsTab();
      case 1: return _buildStationAnalyticsTab();
      case 2: return _buildVehicleHealthTab();
      case 3: return _buildObcDiagnosticTab();
      case 4: return const AdminVehiclesScreen();
      case 5: return const AdminRidesScreen();
      case 6: return _buildManualOverrideTab();
      default: return _buildRideAnalyticsTab();
    }
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    bool isSelected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? StitchColors.primaryContainer.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? StitchColors.primary : StitchColors.onSurfaceVariant, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? StitchColors.primary : StitchColors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRideAnalyticsTab() {
    final List<dynamic> rawCounts = _rideAnalytics['hourlyCounts'] ?? List.filled(24, 0);
    final List<int> hourlyCounts = rawCounts.map((e) => (e as num).toInt()).toList();
    int maxCount = hourlyCounts.fold(1, (max, c) => c > max ? c : max);

    final ratings = _rideAnalytics['ratingsDistribution'] ?? {};
    final totalRatingsCount = ratings.values.fold(0, (sum, val) => sum + (val as num).toInt());
    final List<dynamic> feed = _rideAnalytics['feedbackFeed'] ?? [];
    
    // Derived sentiment variables
    final int positiveRatings = ((ratings['5'] ?? 0) as int) + ((ratings['4'] ?? 0) as int);
    final int neutralRatings = ((ratings['3'] ?? 0) as int);
    final int negativeRatings = ((ratings['2'] ?? 0) as int) + ((ratings['1'] ?? 0) as int);
    final int sumRatings = (5 * ((ratings['5'] ?? 0) as int)) + (4 * ((ratings['4'] ?? 0) as int)) + (3 * ((ratings['3'] ?? 0) as int)) + (2 * ((ratings['2'] ?? 0) as int)) + (1 * ((ratings['1'] ?? 0) as int));
    final double avgStars = totalRatingsCount > 0 ? (sumRatings / totalRatingsCount) : 0.0;
    final int positiveRatio = totalRatingsCount > 0 ? ((positiveRatings / totalRatingsCount) * 100).round() : 0;

    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        // Top 3 Bento Grid Metrics
        Row(
          children: [
            Expanded(
              child: GlassPanel(
                hasGlow: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: StitchColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.route, color: StitchColors.primary),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.trending_up, color: StitchColors.primary, size: 16),
                            const SizedBox(width: 4),
                            Text("+12%", style: const TextStyle(color: StitchColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text("TOTAL COMPLETED TRIPS", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("${_rideAnalytics['totalTrips'] ?? 0}", style: const TextStyle(color: StitchColors.onSurface, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1)),
                    const SizedBox(height: 24),
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(color: StitchColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(3)),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.8,
                        child: Container(decoration: BoxDecoration(color: StitchColors.primary, borderRadius: BorderRadius.circular(3))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: GlassPanel(
                child: Column(
                  children: [
                    const Text("MEAN WAIT TIME (MTBR)", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 140,
                            height: 70,
                            decoration: BoxDecoration(
                              color: StitchColors.surfaceVariant,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(100)),
                            ),
                          ),
                          Container(
                            width: 140,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: StitchColors.primary,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
                            ),
                          ),
                          // Overlay to make it a ring
                          Container(
                            width: 110,
                            height: 55,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1B2332), // approximated glass inner color
                              borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_rideAnalytics['mtbr']?.replaceAll(" min", "") ?? "2.5", style: const TextStyle(color: StitchColors.primary, fontSize: 32, fontWeight: FontWeight.bold)),
                                const Text("minutes", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified, color: StitchColors.primaryContainer, size: 16),
                        const SizedBox(width: 8),
                        const Flexible(child: Text("Optimal Performance Zone", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: GlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: StitchColors.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.groups, color: StitchColors.secondary),
                        ),
                        const Text("Peak Usage", style: TextStyle(color: StitchColors.secondary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text("AVG. OCCUPANCY", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("84%", style: TextStyle(color: StitchColors.onSurface, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1)),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Large Charts Section
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 24-Hour Rush Hour Chart
            Expanded(
              flex: 5,
              child: GlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Rush Hour Analysis", style: TextStyle(color: StitchColors.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("Stacked trip volume over 24-hour period", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
                          child: const Text("Last 24 Hours", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 192,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(24, (index) {
                          final count = hourlyCounts[index];
                          final heightPct = maxCount > 0 ? count / maxCount : 0.0;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (count > 0)
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: (160 * heightPct) * 0.25,
                                            decoration: const BoxDecoration(color: StitchColors.primaryContainer, borderRadius: BorderRadius.vertical(top: Radius.circular(4))),
                                          ),
                                          Container(
                                            height: (160 * heightPct) * 0.75,
                                            color: StitchColors.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  if (index % 4 == 0) Text("${index.toString().padLeft(2, '0')}:00", style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 10)),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: StitchColors.primaryContainer, size: 12),
                        const SizedBox(width: 8),
                        const Text("Regular Commute", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                        const SizedBox(width: 24),
                        const Icon(Icons.circle, color: StitchColors.primary, size: 12),
                        const SizedBox(width: 8),
                        const Text("Event Shuttles", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            // User Sentiment
            Expanded(
              flex: 3,
              child: GlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("User Sentiment", style: TextStyle(color: StitchColors.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("Real-time feedback distribution", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                    const SizedBox(height: 32),
                    _buildSentimentBar("Very Satisfied", (totalRatingsCount > 0 ? positiveRatings / totalRatingsCount : 0), StitchColors.primary),
                    const SizedBox(height: 24),
                    _buildSentimentBar("Neutral", (totalRatingsCount > 0 ? neutralRatings / totalRatingsCount : 0), StitchColors.primary.withOpacity(0.5)),
                    const SizedBox(height: 24),
                    _buildSentimentBar("Dissatisfied", (totalRatingsCount > 0 ? negativeRatings / totalRatingsCount : 0), StitchColors.error),
                    const SizedBox(height: 48),
                    Container(height: 1, color: Colors.white10),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(avgStars.toStringAsFixed(1), style: const TextStyle(color: StitchColors.primary, fontSize: 32, fontWeight: FontWeight.bold)),
                            const Text("AVG. STARS", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("$positiveRatio%", style: const TextStyle(color: StitchColors.secondary, fontSize: 32, fontWeight: FontWeight.bold)),
                            const Text("POSITIVE RATIO", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Live Feedback Stream
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Live Feedback Stream", style: TextStyle(color: StitchColors.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: StitchColors.primary))),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: feed.isEmpty
              ? const Center(child: Text("No written feedback submitted yet.", style: TextStyle(color: StitchColors.onSurfaceVariant)))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: feed.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (c, i) {
                    final item = feed[i];
                    return SizedBox(
                      width: 320,
                      child: GlassPanel(
                        padding: const EdgeInsets.all(20),
                        borderRadius: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['studentEmail'], style: const TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                      const Text("Recent", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (idx) => Icon(Icons.star, size: 14, color: idx < (item['rating'] ?? 0) ? StitchColors.secondary : Colors.white24),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Text(
                                '"${item['feedback'] ?? 'No comment provided'}"',
                                style: const TextStyle(color: StitchColors.onSurfaceVariant, fontStyle: FontStyle.italic),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSentimentBar(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 14)),
            Text("${(percentage * 100).round()}%", style: const TextStyle(color: StitchColors.onSurface, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(color: StitchColors.surfaceContainerLow, borderRadius: BorderRadius.circular(4)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
          ),
        ),
      ],
    );
  }

  // --- CATEGORY 2: STATION ANALYTICS ---
  // --- CATEGORY 2: STATION ANALYTICS ---
  Widget _buildStationAnalyticsTab() {
    final List<dynamic> pickups = _stationAnalytics['pickups'] ?? [];
    final List<dynamic> destinations = _stationAnalytics['destinations'] ?? [];

    int maxPickup = pickups.fold(1, (max, p) => ((p['count'] ?? 0) > max) ? p['count'] : max);
    int maxDest = destinations.fold(1, (max, d) => ((d['count'] ?? 0) > max) ? d['count'] : max);

    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Top Shuttle Hub Traffic", style: TextStyle(color: StitchColors.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("High-demand zones requiring fleet redistribution", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pickup Stations
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: StitchColors.secondary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.my_location, color: StitchColors.secondary, size: 16),
                            ),
                            const SizedBox(width: 12),
                            const Text("Top Pickup Hubs", style: TextStyle(color: StitchColors.secondary, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (pickups.isEmpty)
                          const Text("No operational logs yet.", style: TextStyle(color: StitchColors.onSurfaceVariant))
                        else
                          ...pickups.take(5).map((hub) {
                            final count = hub['count'] ?? 0;
                            final pct = count / maxPickup;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(hub['_id'] ?? "Unknown", style: const TextStyle(color: StitchColors.onSurface, fontSize: 13, fontWeight: FontWeight.bold)),
                                      Text("$count", style: const TextStyle(color: StitchColors.secondary, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(3)),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: pct,
                                      child: Container(decoration: BoxDecoration(color: StitchColors.secondary, borderRadius: BorderRadius.circular(3))),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                  // Destination Stations
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: StitchColors.error.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.location_on, color: StitchColors.error, size: 16),
                            ),
                            const SizedBox(width: 12),
                            const Text("Top Drop-Off Hubs", style: TextStyle(color: StitchColors.error, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (destinations.isEmpty)
                          const Text("No operational logs yet.", style: TextStyle(color: StitchColors.onSurfaceVariant))
                        else
                          ...destinations.take(5).map((hub) {
                            final count = hub['count'] ?? 0;
                            final pct = count / maxDest;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(hub['_id'] ?? "Unknown", style: const TextStyle(color: StitchColors.onSurface, fontSize: 13, fontWeight: FontWeight.bold)),
                                      Text("$count", style: const TextStyle(color: StitchColors.error, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(3)),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: pct,
                                      child: Container(decoration: BoxDecoration(color: StitchColors.error, borderRadius: BorderRadius.circular(3))),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Corridor Spatial Flow Overlay", style: TextStyle(color: StitchColors.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("Live campus map tracking fleet movement and node density", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
              const SizedBox(height: 24),
              Container(
                height: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: const RealCampusMap(showAllStations: true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- CATEGORY 3: VEHICLE HEALTH & POWER STATUS ---
  // --- CATEGORY 3: VEHICLE HEALTH & POWER STATUS ---
  Widget _buildVehicleHealthTab() {
    final List<Map<String, dynamic>> units = [];
    _telemetry.forEach((cartId, data) {
      units.add({
        "cart_id": cartId,
        "battery_pct": (data['battery_pct'] ?? 100.0).toDouble(),
        "power_w": (data['power_w'] ?? 0.0).toDouble(),
        "soh": (data['soh'] ?? 100.0).toDouble(),
      });
    });

    // Sort by highest power drawing unit
    units.sort((a, b) => b['power_w'].compareTo(a['power_w']));

    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        if (units.isEmpty)
          const GlassPanel(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text("Waiting for telemetry data...", style: TextStyle(color: StitchColors.onSurfaceVariant))),
            ),
          )
        else ...[
          // Grid of active vehicle battery status dials
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.8,
            ),
            itemCount: units.length,
            itemBuilder: (context, index) {
              final unit = units[index];
              final double battery = unit['battery_pct'];

              Color ringColor = StitchColors.primary;
              if (battery < 20.0) {
                ringColor = StitchColors.error;
              } else if (battery <= 50.0) {
                ringColor = StitchColors.secondary;
              }

              return GlassPanel(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    // Radial Battery Ring
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: battery / 100.0,
                            strokeWidth: 8,
                            color: ringColor,
                            backgroundColor: StitchColors.surfaceContainerHighest,
                          ),
                        ),
                        Text(
                          "${battery.toStringAsFixed(0)}%",
                          style: const TextStyle(color: StitchColors.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(unit['cart_id'], style: const TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold, fontSize: 18)),
                              Icon(Icons.bolt, color: ringColor, size: 20),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Health (SoH): ${unit['soh']}%", style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text("Draw: ${unit['power_w'].toStringAsFixed(0)} W", style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Real-Time Power Consumption Line Chart Card
              Expanded(
                flex: 5,
                child: GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Real-Time Fleet Power consumption", style: TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 4),
                      const Text("Live tracking of total energy consumption trend over time (Watts Draw)", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                      const SizedBox(height: 32),
                      // Render the CustomPainter real-time chart using the current power of all carts combined
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: StitchColors.surfaceContainerLowest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: RealTimePowerChart(
                          currentPower: units.isNotEmpty
                              ? units.map((u) => u['power_w'] as double).reduce((a, b) => a + b)
                              : 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Power Consumption Leaderboard
              Expanded(
                flex: 3,
                child: GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Power Draw Leaderboard", style: TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 4),
                      const Text("Highest consuming units", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                      const SizedBox(height: 24),
                      ...List.generate(units.length, (idx) {
                        final unit = units[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, shape: BoxShape.circle),
                                child: Text("#${idx + 1}", style: const TextStyle(color: StitchColors.onSurfaceVariant, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(unit['cart_id'], style: const TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold)),
                                    Text("SoC: ${unit['battery_pct']}%", style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text("${unit['power_w']} W", style: const TextStyle(color: StitchColors.error, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // --- CATEGORY 4: OBC DIAGNOSTIC MATRIX ---
  // --- CATEGORY 4: OBC DIAGNOSTIC MATRIX ---
  Widget _buildObcDiagnosticTab() {
    final List<Map<String, dynamic>> matrixData = [];
    _telemetry.forEach((cartId, data) {
      matrixData.add({
        "cart_id": cartId,
        "plc_esp": (data['plc_status'] == 1 && data['esp_status'] == 1) ? 1 : 0,
        "left_us": data['left_ultrasonic'] ?? 1,
        "right_us": data['right_ultrasonic'] ?? 1,
        "rear_us": data['rear_ultrasonic'] ?? 1,
        "lidar": data['lidar_status'] ?? 1,
        "imu": data['imu_status'] ?? 1,
        "gps": data['gps_status'] ?? 1,
        "encoder": data['encoder_status'] ?? 1,
        "rail_24v": data['rail_24v_status'] ?? 1,
        "rail_5v": data['rail_5v_status'] ?? 1,
        "acs712": data['acs712_status'] ?? 1,
        "rssi": (data['rssi'] ?? -65).toInt(),
        "uptime": (data['uptime_pct'] ?? 99.8).toDouble(),
      });
    });

    Widget statusDot(int status) {
      Color dotColor = StitchColors.primary;
      if (status == 0) dotColor = StitchColors.error;
      return Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
      );
    }

    Widget wifiBars(int rssi) {
      int bars = 0;
      if (rssi > -60) {
        bars = 4;
      } else if (rssi > -70)
        bars = 3;
      else if (rssi > -80)
        bars = 2;
      else if (rssi > -90)
        bars = 1;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          4,
          (index) => Container(
            width: 4,
            height: (index + 1) * 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: index < bars ? StitchColors.primary : StitchColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      );
    }

    Widget _header(String text) => TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: StitchColors.onSurfaceVariant)),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("System Diagnostic Matrix", style: TextStyle(color: StitchColors.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("Live sensor and payload status from all fleet On-Board Computers (OBC)", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
              const SizedBox(height: 32),
              if (matrixData.isEmpty)
                const Center(child: Text("No telemetry reports available.", style: TextStyle(color: StitchColors.onSurfaceVariant)))
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Table(
                      defaultColumnWidth: const FixedColumnWidth(90),
                      border: TableBorder.symmetric(
                        inside: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: StitchColors.surfaceContainerLowest.withOpacity(0.5)),
                          children: [
                            _header("Cart ID"),
                            _header("PLC/ESP"),
                            _header("Left US"),
                            _header("Right US"),
                            _header("Rear US"),
                            _header("LiDAR"),
                            _header("IMU"),
                            _header("GPS"),
                            _header("Encoder"),
                            _header("24V Rail"),
                            _header("5V Rail"),
                            _header("ACS-712"),
                          ],
                        ),
                        ...matrixData.map(
                          (row) => TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Text(row['cart_id'], style: const TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
                                ),
                              ),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['plc_esp']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['left_us']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['right_us']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['rear_us']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['lidar']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['imu']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['gps']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['encoder']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['rail_24v']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['rail_5v']))),
                              TableCell(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: statusDot(row['acs712']))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Network Connectivity Reliability", style: TextStyle(color: StitchColors.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("Live RSSI and uptime metrics from ESP chips", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)),
              const SizedBox(height: 24),
              if (matrixData.isEmpty)
                const SizedBox.shrink()
              else
                ...matrixData.map(
                  (row) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: StitchColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.wifi, color: StitchColors.primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(row['cart_id'], style: const TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text("Signal Quality: ", style: TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 13)),
                                  wifiBars(row['rssi']),
                                  const SizedBox(width: 8),
                                  Text("${row['rssi']} dBm", style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: StitchColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                          child: Text("Uptime ${row['uptime']}%", style: const TextStyle(color: StitchColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            radius: 24,
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendControlUpdate({bool immediate = false}) {
    if (!immediate) {
      if (_throttleTimer?.isActive ?? false) return; // Debounce/throttle to max 5/sec (200ms)
      _throttleTimer = Timer(const Duration(milliseconds: 200), () => _sendControlUpdate(immediate: true));
      return;
    }
    
    _lastControlSend = DateTime.now();
    ApiService.postAdminControl({
      'estop': _estopActive,
      'mode': _mode,
      'manual_command': _manualCommand,
      'manual_throttle': _manualThrottle,
    });
  }

  void _triggerEstop() {
    setState(() {
      _estopActive = true;
      _mode = 'manual';
      _manualCommand = 'stop';
      _manualThrottle = 0.0;
    });
    _sendControlUpdate(immediate: true);
  }

  void _releaseEstop() {
    setState(() => _estopActive = false);
    _sendControlUpdate(immediate: true);
  }

  Widget _buildManualOverrideTab() {
    final cartData = _telemetry['CK-001'] ?? {};
    final bool isOnline = cartData['updated_at'] != null && DateTime.now().difference(DateTime.parse(cartData['updated_at'])) < const Duration(seconds: 5);
    final double speed = (cartData['speed_kmh'] ?? 0.0).toDouble();
    final int node = cartData['current_node'] ?? 0;
    final int pax = cartData['on_board_count'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Telemetry Heartbeat Monitor
          GlassPanel(
            child: Row(
              children: [
                Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.greenAccent : StitchColors.error,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: (isOnline ? Colors.greenAccent : StitchColors.error).withOpacity(0.5), blurRadius: 10)],
                  ),
                ),
                const SizedBox(width: 16),
                const Text("CART-01 LINK STATUS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: StitchColors.onSurface)),
                const Spacer(),
                _buildTelemetryPill(Icons.speed, "${speed.toStringAsFixed(1)} km/h"),
                const SizedBox(width: 12),
                _buildTelemetryPill(Icons.location_on, "Node $node"),
                const SizedBox(width: 12),
                _buildTelemetryPill(Icons.people, "$pax Pax"),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // EMERGENCY STOP SECTION
          Center(
            child: GestureDetector(
              onTap: _estopActive ? null : _triggerEstop,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _estopActive ? StitchColors.error : StitchColors.error.withOpacity(0.2),
                  border: Border.all(color: StitchColors.error, width: 4),
                  boxShadow: _estopActive ? [BoxShadow(color: StitchColors.error.withOpacity(0.8), blurRadius: 50, spreadRadius: 10)] : [],
                ),
                child: Center(
                  child: Text(
                    _estopActive ? "E-STOP\nACTIVATED" : "EMERGENCY\nSTOP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: _estopActive ? Colors.white : StitchColors.error,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_estopActive) ...[
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 300,
                child: Slider(
                  value: 0,
                  onChanged: (val) {
                    if (val > 0.9) _releaseEstop();
                  },
                  activeColor: StitchColors.error,
                  inactiveColor: StitchColors.surfaceContainerLowest,
                  label: "Swipe right to reset",
                ),
              ),
            ),
            const Center(child: Text("Swipe right to reset E-Stop", style: TextStyle(color: StitchColors.onSurfaceVariant))),
          ],
          
          const SizedBox(height: 48),

          // MODE SELECTOR
          GlassPanel(
            child: Row(
              children: [
                const Text("OPERATIONAL MODE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: StitchColors.onSurface)),
                const Spacer(),
                ToggleButtons(
                  isSelected: [_mode == 'auto', _mode == 'manual'],
                  onPressed: (index) {
                    if (index == 1 && _mode != 'manual') {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: StitchColors.surfaceContainerLowest,
                          title: const Text("Confirm Manual Override", style: TextStyle(color: StitchColors.error)),
                          content: const Text("Warning: Switching to manual mode will immediately cancel all active ride requests. Proceed?", style: TextStyle(color: StitchColors.onSurface)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL")),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: StitchColors.error),
                              onPressed: () {
                                Navigator.pop(ctx);
                                setState(() => _mode = 'manual');
                                _sendControlUpdate(immediate: true);
                              },
                              child: const Text("PROCEED"),
                            ),
                          ],
                        ),
                      );
                    } else if (index == 0) {
                      setState(() => _mode = 'auto');
                      _sendControlUpdate(immediate: true);
                    }
                  },
                  fillColor: StitchColors.primary.withOpacity(0.2),
                  selectedColor: StitchColors.primary,
                  color: StitchColors.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  children: const [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Text("AUTO")),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Text("MANUAL")),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // MANUAL DRIVE MODULE
          if (_mode == 'manual')
            GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("MANUAL DRIVE CONTROLS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: StitchColors.primary)),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Direction
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("DIRECTION", style: TextStyle(color: StitchColors.onSurfaceVariant)),
                            const SizedBox(height: 12),
                            ToggleButtons(
                              isSelected: [_manualCommand == 'forward', _manualCommand == 'reverse'],
                              onPressed: (index) {
                                setState(() {
                                  _manualCommand = index == 0 ? 'forward' : 'reverse';
                                  _manualThrottle = 0.0;
                                });
                                _sendControlUpdate(immediate: true);
                              },
                              fillColor: StitchColors.secondary.withOpacity(0.2),
                              selectedColor: StitchColors.secondary,
                              color: StitchColors.onSurfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                              children: const [
                                Padding(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), child: Text("FORWARD")),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), child: Text("REVERSE")),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: StitchColors.error,
                                      padding: const EdgeInsets.symmetric(vertical: 24),
                                    ),
                                    onPressed: () {
                                      setState(() { _manualCommand = 'stop'; _manualThrottle = 0; });
                                      _sendControlUpdate(immediate: true);
                                    },
                                    child: const Text("STOP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      padding: const EdgeInsets.symmetric(vertical: 24),
                                    ),
                                    onPressed: () {
                                      setState(() { _manualCommand = 'brake'; _manualThrottle = 0; });
                                      _sendControlUpdate(immediate: true);
                                    },
                                    child: const Text("BRAKE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      // Throttle
                      Column(
                        children: [
                          const Text("THROTTLE", style: TextStyle(color: StitchColors.onSurfaceVariant)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Slider(
                                value: _manualThrottle,
                                min: 0, max: 100,
                                activeColor: StitchColors.primary,
                                inactiveColor: StitchColors.primary.withOpacity(0.1),
                                onChanged: (val) {
                                  if (_manualCommand != 'forward' && _manualCommand != 'reverse') return;
                                  setState(() => _manualThrottle = val);
                                  _sendControlUpdate();
                                },
                                onChangeEnd: (val) {
                                  // Deadman switch snap back
                                  setState(() => _manualThrottle = 0);
                                  _sendControlUpdate(immediate: true);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text("${_manualThrottle.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: StitchColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTelemetryPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: StitchColors.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: StitchColors.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: StitchColors.onSurface)),
        ],
      ),
    );
  }
}

// --- 2. VEHICLES SCREEN ---
class AdminVehiclesScreen extends StatefulWidget {
  const AdminVehiclesScreen({super.key});
  @override
  State<AdminVehiclesScreen> createState() => _AdminVehiclesScreenState();
}

class _AdminVehiclesScreenState extends State<AdminVehiclesScreen> {
  Map<String, dynamic> _telemetry = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchTelemetry();
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _fetchTelemetry(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchTelemetry() async {
    final data = await ApiService.getLatestTelemetry();
    if (mounted) {
      setState(() {
        _telemetry = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Fleet Vehicle Monitor (Live Locations)", style: TextStyle(color: StitchColors.onSurface, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: RealCampusMap(
                  cartLocation: _telemetry.isNotEmpty
                      ? LatLng(
                          _telemetry[_telemetry.keys.first]['lat'] ?? 29.431068,
                          _telemetry[_telemetry.keys.first]['lng'] ?? 32.401685,
                        )
                      : null,
                  showAllStations: true,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: GlassPanel(
              child: ListView.separated(
                itemCount: _telemetry.keys.isNotEmpty ? _telemetry.keys.length : 1,
                separatorBuilder: (_, i) => const Divider(color: Colors.white10),
                itemBuilder: (c, i) {
                  if (_telemetry.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Waiting for telemetry data...", style: TextStyle(color: StitchColors.onSurfaceVariant)),
                    );
                  }

                  final cartId = _telemetry.keys.elementAt(i);
                  final cartData = _telemetry[cartId];
                  final speed = cartData['speed_kmh']?.toStringAsFixed(1) ?? "0.0";
                  final battery = cartData['battery_pct']?.toStringAsFixed(1) ?? "0.0";
                  final batteryValue = (cartData['battery_pct'] ?? 0.0) / 100.0;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: StitchColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.electric_car, color: StitchColors.primary),
                    ),
                    title: Text(cartId, style: const TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Speed: $speed km/h • Power: ${cartData['power_w'] ?? 0.0} W", style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 13)),
                        const SizedBox(height: 8),
                        Container(
                          height: 6,
                          decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(3)),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: batteryValue,
                            child: Container(decoration: BoxDecoration(color: StitchColors.primary, borderRadius: BorderRadius.circular(3))),
                          ),
                        ),
                      ],
                    ),
                    trailing: Text("$battery%", style: const TextStyle(color: StitchColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- 3. RIDES SCREEN ---
class AdminRidesScreen extends StatefulWidget {
  const AdminRidesScreen({super.key});
  @override
  State<AdminRidesScreen> createState() => _AdminRidesScreenState();
}

class _AdminRidesScreenState extends State<AdminRidesScreen> {
  List<dynamic> _rides = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  Future<void> _loadRides() async {
    final data = await ApiService.getAllRides();
    if (mounted) {
      setState(() {
        _rides = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Ride Management Log", style: TextStyle(color: StitchColors.onSurface, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: GlassPanel(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: StitchColors.primary))
                  : RefreshIndicator(
                      onRefresh: _loadRides,
                      color: StitchColors.primary,
                      backgroundColor: StitchColors.surfaceContainerHigh,
                      child: ListView.separated(
                        itemCount: _rides.length,
                        separatorBuilder: (_, i) => const Divider(color: Colors.white10),
                        itemBuilder: (c, i) {
                          final ride = _rides[i];
                          final status = ride['status'] ?? 'pending';
                          final rating = ride['rating'] ?? 0;
                          final feedback = ride['feedback'] ?? '';
                          final studentEmail = ride['studentEmail'] ?? "Unknown Student";

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, shape: BoxShape.circle),
                                      child: const Icon(Icons.person, color: StitchColors.onSurfaceVariant),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(studentEmail, style: const TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(status).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        status.toUpperCase(),
                                        style: TextStyle(color: _getStatusColor(status), fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.alt_route, color: StitchColors.primary, size: 20),
                                    const SizedBox(width: 12),
                                    Text(
                                      "${ride['pickup']['name']} ➔ ${ride['destination']['name']}",
                                      style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 14),
                                    ),
                                  ],
                                ),
                                if (rating > 0) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 20),
                                      const SizedBox(width: 8),
                                      Text("Rating: $rating / 5", style: const TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                                if (feedback.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: StitchColors.surfaceContainerLowest.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
                                    child: Text("\"$feedback\"", style: const TextStyle(fontStyle: FontStyle.italic, color: StitchColors.onSurfaceVariant)),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return StitchColors.primary;
      case 'cancelled':
        return StitchColors.error;
      case 'pending':
        return StitchColors.secondary;
      default:
        return StitchColors.onSurfaceVariant;
    }
  }
}

// --- NEW CUSTOM INSIGHT WIDGETS & PAINTERS ---

class MtbrGauge extends StatelessWidget {
  final double waitTimeMin;
  const MtbrGauge({super.key, required this.waitTimeMin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 90,
      alignment: Alignment.center,
      child: CustomPaint(
        size: const Size(140, 90),
        painter: GaugePainter(value: waitTimeMin, maxVal: 10.0),
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final double maxVal;

  GaugePainter({required this.value, required this.maxVal});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2 - 10;

    final basePaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      basePaint,
    );

    final double sweepAngle = (value / maxVal).clamp(0.0, 1.0) * math.pi;

    if (value > 7.0) {
      progressPaint.color = Colors.red;
    } else if (value > 4.0) {
      progressPaint.color = Colors.orange;
    } else {
      progressPaint.color = AppColors.primaryGreen;
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweepAngle,
      false,
      progressPaint,
    );

    final needlePaint = Paint()
      ..color = AppColors.primaryNavy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final needleAngle = math.pi + sweepAngle;
    final needleEnd = Offset(
      center.dx + (radius - 15) * math.cos(needleAngle),
      center.dy + (radius - 15) * math.sin(needleAngle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(center, 6.0, Paint()..color = AppColors.primaryNavy);
    canvas.drawCircle(center, 3.0, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.maxVal != maxVal;
}

class RealTimePowerChart extends StatefulWidget {
  final double currentPower;
  const RealTimePowerChart({super.key, required this.currentPower});

  @override
  State<RealTimePowerChart> createState() => _RealTimePowerChartState();
}

class _RealTimePowerChartState extends State<RealTimePowerChart> {
  final List<double> _history = [];

  @override
  void didUpdateWidget(covariant RealTimePowerChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPower != oldWidget.currentPower || _history.isEmpty) {
      setState(() {
        _history.add(widget.currentPower);
        if (_history.length > 15) {
          _history.removeAt(0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: CustomPaint(painter: PowerLineChartPainter(points: _history)),
    );
  }
}

class PowerLineChartPainter extends CustomPainter {
  final List<double> points;
  PowerLineChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    double maxVal = 100.0;
    double minVal = 0.0;
    for (var p in points) {
      if (p > maxVal) maxVal = p;
    }
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final path = ui.Path();
    final fillPath = ui.Path();

    final double stepX =
        size.width / (points.length - 1 == 0 ? 1 : points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final double x = i * stepX;
      final double normalizedY = (points[i] - minVal) / range;
      final double y = size.height - (normalizedY * (size.height - 20) + 10);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      if (i == points.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4.0);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    fillPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primaryGreen.withOpacity(0.3),
        AppColors.primaryGreen.withOpacity(0.0),
      ],
    ).createShader(rect);

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    final pointPaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.fill;
    final outerPointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < points.length; i++) {
      final double x = i * stepX;
      final double normalizedY = (points[i] - minVal) / range;
      final double y = size.height - (normalizedY * (size.height - 20) + 10);

      canvas.drawCircle(Offset(x, y), 5.5, pointPaint);
      canvas.drawCircle(Offset(x, y), 5.5, outerPointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PowerLineChartPainter oldDelegate) =>
      oldDelegate.points != points;
}
