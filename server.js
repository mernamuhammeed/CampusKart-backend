const express = require('express');
const path = require('path');
const mongoose = require('mongoose');
const cors = require('cors');
const { InfluxDB, Point } = require('@influxdata/influxdb-client');

const token = 'TXdoAl9KinoutbpGdnWJEUnjvj9lfw4ucL_MRj14H1WBBXGxcMrsVawokHZ1-OYsnWI6Rf8uLY8M8JbA_O_5aw==';
const url = 'http://localhost:8086';
const org = 'CampusKart';
const bucket = 'CampusKart';

const influxDB = new InfluxDB({ url, token });
const writeApi = influxDB.getWriteApi(org, bucket, 'ns');
const queryApi = influxDB.getQueryApi(org);

const originalFindOne = mongoose.Model.findOne;

mongoose.Model.findOne = function (query, projection, callback) {
    console.log("🧪 DB FIND ONE CALLED WITH:", query);
    
    if (typeof projection === 'function') {
        // Standard Mongoose way
        return originalFindOne.apply(this, arguments);
    } else {
        // Method 2 way
        return originalFindOne.call(this, query, projection);
    }
};
const app = express();
app.use(cors());
app.use(express.json());

// Serve the Flutter web app
app.use(express.static(path.join(__dirname, 'public')));

// 1. Connect to MongoDB
mongoose.connect('mongodb+srv://GolfCarAdmin:pass1234@golfcar.i9jx33e.mongodb.net/') 
    .then(() => console.log('✅ MongoDB Connected'))
    .catch(err => console.error('❌ Connection error:', err));

// 2. Define Schema
const CRITICAL_BATTERY_THRESHOLD = 20.0;

const rideSchema = new mongoose.Schema({
    studentEmail: String,
    pickup: { name: String, distance: String, eta: String },
    destination: { name: String, distance: String, eta: String },
    status: { type: String, default: 'pending' },
    eta_min: { type: String, default: '0s' },
    distance_m: { type: Number, default: 0 },
    rating: { type: Number, default: 0 }, // Added rating field
    feedback: { type: String, default: '' }, // Added feedback field
    path_index: { type: Number, default: -1 }, // To track simulation progress
    live_cart_lat: { type: Number, default: 0 },
    live_cart_lon: { type: Number, default: 0 },
    updatedAt: { type: String },
    navigation: { type: Object },
    createdAt: { type: Date, default: Date.now }
});

const userSchema = new mongoose.Schema({
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    name: { type: String, default: '' },
});
const User = mongoose.model('User', userSchema);
const Ride = mongoose.model('Ride', rideSchema);

// Navigation Data for simulation
const kStationCoords = {
    'Admission Station': { lat: 29.43107812, lon: 32.40167970 },
    'Engineering Station': { lat: 29.43355847, lon: 32.39782279 },
    'Arts & Design Station': { lat: 29.43288092, lon: 32.39706283 },
    'CS & Eng Station': { lat: 29.43024508, lon: 32.39937072 },
    'Pharmacy Station': { lat: 29.42801924, lon: 32.40190099 },
    'Nursing Station': { lat: 29.42742306, lon: 32.40280592 },
    'Medical Station': { lat: 29.42654577, lon: 32.40400374 },
    'Dentistry Station': { lat: 29.42828960, lon: 32.40561523 },
    'Physical Therapy Station': { lat: 29.42928356, lon: 32.40415616 },
    'Applied Health Station': { lat: 29.42998180, lon: 32.40316778 },
    'Science Station': { lat: 29.43192535, lon: 32.40053784 },
};

const kAllNodes = [
    { lat: 29.43118703, lon: 32.40160259 }, // 0: Admission Station (Node 0)
    { lat: 29.43121880, lon: 32.40155726 }, // 1: Admission Station (Node 1)
    { lat: 29.43124173, lon: 32.40151417 }, // 2: Road Node 2
    { lat: 29.43129136, lon: 32.40143157 }, // 3: Road Node 3
    { lat: 29.43133379, lon: 32.40136337 }, // 4: Road Node 4
    { lat: 29.43137421, lon: 32.40130343 }, // 5: Road Node 5
    { lat: 29.43140298, lon: 32.40126546 }, // 6: Road Node 6
    { lat: 29.43143592, lon: 32.40121975 }, // 7: Road Node 7
    { lat: 29.43146443, lon: 32.40118051 }, // 8: Road Node 8
    { lat: 29.43157970, lon: 32.40102833 }, // 9: Road Node 9
    { lat: 29.43167444, lon: 32.40090357 }, // 10: Road Node 10
    { lat: 29.43181307, lon: 32.40071941 }, // 11: Science Station (Node 11)
    { lat: 29.43190802, lon: 32.40059569 }, // 12: Science Station (Node 12)
    { lat: 29.43204901, lon: 32.40041603 }, // 13: Science Station (Node 13)
    { lat: 29.43217263, lon: 32.40025371 }, // 14: Road Node 14
    { lat: 29.43233211, lon: 32.40005220 }, // 15: Road Node 15
    { lat: 29.43246485, lon: 32.39987910 }, // 16: Road Node 16
    { lat: 29.43256982, lon: 32.39975405 }, // 17: Road Node 17
    { lat: 29.43265604, lon: 32.39965054 }, // 18: Road Node 18
    { lat: 29.43273365, lon: 32.39955402 }, // 19: Road Node 19
    { lat: 29.43281242, lon: 32.39946382 }, // 20: Road Node 20
    { lat: 29.43291935, lon: 32.39934708 }, // 21: Road Node 21
    { lat: 29.43304649, lon: 32.39921275 }, // 22: Road Node 22
    { lat: 29.43315932, lon: 32.39909256 }, // 23: Road Node 23
    { lat: 29.43327805, lon: 32.39896504 }, // 24: Road Node 24
    { lat: 29.43340428, lon: 32.39882546 }, // 25: Road Node 25
    { lat: 29.43356871, lon: 32.39863110 }, // 26: Road Node 26
    { lat: 29.43368862, lon: 32.39849360 }, // 27: Road Node 27
    { lat: 29.43377799, lon: 32.39839435 }, // 28: Turn Corner1 Node 28
    { lat: 29.43380399, lon: 32.39835794 }, // 29: Turn Corner1 Node 29
    { lat: 29.43382288, lon: 32.39831704 }, // 30: Turn Corner1 Node 30
    { lat: 29.43383085, lon: 32.39828813 }, // 31: Turn Corner1 Node 31
    { lat: 29.43383813, lon: 32.39825120 }, // 32: Turn Corner1 Node 32
    { lat: 29.43383844, lon: 32.39822562 }, // 33: Turn Corner1 Node 33
    { lat: 29.43383599, lon: 32.39819344 }, // 34: Turn Corner1 Node 34
    { lat: 29.43382960, lon: 32.39816697 }, // 35: Turn Corner1 Node 35
    { lat: 29.43382223, lon: 32.39813936 }, // 36: Turn Corner1 Node 36
    { lat: 29.43381338, lon: 32.39811125 }, // 37: Turn Corner1 Node 37
    { lat: 29.43379651, lon: 32.39807497 }, // 38: Turn Corner1 Node 38
    { lat: 29.43377924, lon: 32.39804805 }, // 39: Reg Bump 1
    { lat: 29.43375605, lon: 32.39801852 }, // 40: Turn Corner1 Node 40
    { lat: 29.43373766, lon: 32.39799869 }, // 41: Road Node 41
    { lat: 29.43372191, lon: 32.39798169 }, // 42: Road Node 42
    { lat: 29.43370186, lon: 32.39795936 }, // 43: Engineering Station (Node 43)
    { lat: 29.43361581, lon: 32.39785773 }, // 44: Engineering Station (Node 44)
    { lat: 29.43353809, lon: 32.39776640 }, // 45: Engineering Station (Node 45)
    { lat: 29.43346843, lon: 32.39768216 }, // 46: Engineering Station (Node 46)
    { lat: 29.43339088, lon: 32.39759405 }, // 47: Road Node 47
    { lat: 29.43330418, lon: 32.39749848 }, // 48: Road Node 48
    { lat: 29.43322261, lon: 32.39740778 }, // 49: Road Node 49
    { lat: 29.43312745, lon: 32.39729800 }, // 50: Road Node 50
    { lat: 29.43303896, lon: 32.39719780 }, // 51: Arts & Design Station (Node 51)
    { lat: 29.43298257, lon: 32.39713847 }, // 52: Arts & Design Station (Node 52)
    { lat: 29.43291259, lon: 32.39706212 }, // 53: Arts & Design Station (Node 53)
    { lat: 29.43286608, lon: 32.39701248 }, // 54: Arts & Design Station (Node 54)
    { lat: 29.43280875, lon: 32.39695322 }, // 55: Arts & Design Station (Node 55)
    { lat: 29.43276318, lon: 32.39691352 }, // 56: Arts & Design Station (Node 56)
    { lat: 29.43272036, lon: 32.39688042 }, // 57: Road Node 57
    { lat: 29.43267726, lon: 32.39684841 }, // 58: Road Node 58
    { lat: 29.43263870, lon: 32.39682203 }, // 59: Road Node 59
    { lat: 29.43259614, lon: 32.39680216 }, // 60: Road Node 60
    { lat: 29.43255404, lon: 32.39677990 }, // 61: Road Node 61
    { lat: 29.43251439, lon: 32.39676346 }, // 62: Road Node 62
    { lat: 29.43247978, lon: 32.39674902 }, // 63: Road Node 63
    { lat: 29.43243913, lon: 32.39673316 }, // 64: Road Node 64
    { lat: 29.43241082, lon: 32.39671672 }, // 65: Road Node 65
    { lat: 29.43239191, lon: 32.39669955 }, // 66: Road Node 66
    { lat: 29.43237297, lon: 32.39667911 }, // 67: Road Node 67
    { lat: 29.43235774, lon: 32.39666061 }, // 68: Roundabout Node 68
    { lat: 29.43235756, lon: 32.39663887 }, // 69: Roundabout Node 69
    { lat: 29.43235082, lon: 32.39660905 }, // 70: Roundabout Node 70
    { lat: 29.43233840, lon: 32.39657699 }, // 71: Roundabout Node 71
    { lat: 29.43231696, lon: 32.39654130 }, // 72: Roundabout Node 72
    { lat: 29.43229826, lon: 32.39651568 }, // 73: Roundabout Node 73
    { lat: 29.43228401, lon: 32.39650030 }, // 74: Roundabout Node 74
    { lat: 29.43226491, lon: 32.39648283 }, // 75: Roundabout Node 75
    { lat: 29.43222538, lon: 32.39646745 }, // 76: Roundabout Node 76
    { lat: 29.43219810, lon: 32.39646117 }, // 77: Roundabout Node 77
    { lat: 29.43217754, lon: 32.39646123 }, // 78: Roundabout Node 78
    { lat: 29.43214904, lon: 32.39646942 }, // 79: Roundabout Node 79
    { lat: 29.43212053, lon: 32.39648393 }, // 80: Roundabout Node 80
    { lat: 29.43208955, lon: 32.39650629 }, // 81: Roundabout Node 81
    { lat: 29.43205657, lon: 32.39654461 }, // 82: Roundabout Node 82
    { lat: 29.43203435, lon: 32.39659049 }, // 83: Roundabout Node 83
    { lat: 29.43202763, lon: 32.39663243 }, // 84: Roundabout Node 84
    { lat: 29.43202970, lon: 32.39666958 }, // 85: Roundabout Node 85
    { lat: 29.43203830, lon: 32.39671066 }, // 86: Roundabout Node 86
    { lat: 29.43205306, lon: 32.39674366 }, // 87: Roundabout Node 87
    { lat: 29.43206649, lon: 32.39676634 }, // 88: Roundabout Node 88
    { lat: 29.43209119, lon: 32.39679142 }, // 89: Roundabout Node 89
    { lat: 29.43212109, lon: 32.39680484 }, // 90: Roundabout Node 90
    { lat: 29.43215722, lon: 32.39681906 }, // 91: Roundabout Node 91
    { lat: 29.43218957, lon: 32.39681762 }, // 92: Roundabout Node 92
    { lat: 29.43223211, lon: 32.39680888 }, // 93: Roundabout Node 93
    { lat: 29.43226568, lon: 32.39679396 }, // 94: Roundabout Node 94
    { lat: 29.43229605, lon: 32.39677175 }, // 95: Roundabout Node 95
    { lat: 29.43233026, lon: 32.39674294 }, // 96: Roundabout Node 96
    { lat: 29.43198191, lon: 32.39672069 }, // 97: Road Node 97
    { lat: 29.43191618, lon: 32.39679532 }, // 98: Road Node 98
    { lat: 29.43186027, lon: 32.39686344 }, // 99: Reg Bump 21
    { lat: 29.43178889, lon: 32.39694910 }, // 100: Road Node 100
    { lat: 29.43174071, lon: 32.39700818 }, // 101: Road Node 101
    { lat: 29.43166892, lon: 32.39709465 }, // 102: Road Node 102
    { lat: 29.43157939, lon: 32.39720599 }, // 103: Road Node 103
    { lat: 29.43150595, lon: 32.39729762 }, // 104: Road Node 104
    { lat: 29.43144089, lon: 32.39737387 }, // 105: Spiked Bump 5
    { lat: 29.43137739, lon: 32.39745251 }, // 106: Road Node 106
    { lat: 29.43130839, lon: 32.39753529 }, // 107: Road Node 107
    { lat: 29.43123970, lon: 32.39761097 }, // 108: Road Node 108
    { lat: 29.43113286, lon: 32.39773667 }, // 109: Road Node 109
    { lat: 29.43099900, lon: 32.39789322 }, // 110: Road Node 110
    { lat: 29.43085405, lon: 32.39806438 }, // 111: Road Node 111
    { lat: 29.43071638, lon: 32.39823113 }, // 112: Road Node 112
    { lat: 29.43063433, lon: 32.39832273 }, // 113: Road Node 113
    { lat: 29.43055371, lon: 32.39842077 }, // 114: Spiked Bump 3
    { lat: 29.43044497, lon: 32.39854244 }, // 115: Road Node 115
    { lat: 29.43038765, lon: 32.39861427 }, // 116: Reg Bump 19
    { lat: 29.43029148, lon: 32.39871638 }, // 117: Road Node 117
    { lat: 29.43026035, lon: 32.39872484 }, // 118: Roundabout Node 118
    { lat: 29.43023489, lon: 32.39872414 }, // 119: Roundabout Node 119
    { lat: 29.43021136, lon: 32.39872233 }, // 120: Road Node 120
    { lat: 29.43018204, lon: 32.39871632 }, // 121: Roundabout Node 121
    { lat: 29.43013685, lon: 32.39871973 }, // 122: Roundabout Node 122
    { lat: 29.43009147, lon: 32.39873699 }, // 123: Roundabout Node 123
    { lat: 29.43006510, lon: 32.39875734 }, // 124: Roundabout Node 124
    { lat: 29.43004047, lon: 32.39878033 }, // 125: Roundabout Node 125
    { lat: 29.43002061, lon: 32.39880839 }, // 126: Roundabout Node 126
    { lat: 29.42999908, lon: 32.39884474 }, // 127: Roundabout Node 127
    { lat: 29.42998808, lon: 32.39888795 }, // 128: Roundabout Node 128
    { lat: 29.42998699, lon: 32.39893303 }, // 129: Roundabout Node 129
    { lat: 29.42998883, lon: 32.39896286 }, // 130: Roundabout Node 130
    { lat: 29.42999703, lon: 32.39899198 }, // 131: Roundabout Node 131
    { lat: 29.43001323, lon: 32.39902303 }, // 132: Roundabout Node 132
    { lat: 29.43003122, lon: 32.39904642 }, // 133: Roundabout Node 133
    { lat: 29.43004989, lon: 32.39906513 }, // 134: Roundabout Node 134
    { lat: 29.43007061, lon: 32.39908329 }, // 135: Roundabout Node 135
    { lat: 29.43009720, lon: 32.39909917 }, // 136: Roundabout Node 136
    { lat: 29.43012257, lon: 32.39910914 }, // 137: Roundabout Node 137
    { lat: 29.43014797, lon: 32.39911353 }, // 138: Roundabout Node 138
    { lat: 29.43017339, lon: 32.39911362 }, // 139: Roundabout Node 139
    { lat: 29.43020231, lon: 32.39910801 }, // 140: Roundabout Node 140
    { lat: 29.43022473, lon: 32.39910347 }, // 141: Roundabout Node 141
    { lat: 29.43025400, lon: 32.39908628 }, // 142: Roundabout Node 142
    { lat: 29.43028330, lon: 32.39906317 }, // 143: Roundabout Node 143
    { lat: 29.43030710, lon: 32.39903027 }, // 144: Roundabout Node 144
    { lat: 29.43031865, lon: 32.39899790 }, // 145: Roundabout Node 145
    { lat: 29.43032544, lon: 32.39896611 }, // 146: Roundabout Node 146
    { lat: 29.43033321, lon: 32.39892931 }, // 147: Roundabout Node 147
    { lat: 29.43033412, lon: 32.39889962 }, // 148: Roundabout Node 148
    { lat: 29.43032903, lon: 32.39886428 }, // 149: Roundabout Node 149
    { lat: 29.43031840, lon: 32.39882726 }, // 150: Roundabout Node 150
    { lat: 29.43030352, lon: 32.39879552 }, // 151: Roundabout Node 151
    { lat: 29.43028064, lon: 32.39876665 }, // 152: Roundabout Node 152
    { lat: 29.42997195, lon: 32.39884218 }, // 153: Road Node 153
    { lat: 29.42992508, lon: 32.39885436 }, // 154: Road Node 154
    { lat: 29.42988288, lon: 32.39885787 }, // 155: Reg Bump 17
    { lat: 29.42982450, lon: 32.39885421 }, // 156: Road Node 156
    { lat: 29.42978552, lon: 32.39884817 }, // 157: Road Node 157
    { lat: 29.42972358, lon: 32.39883861 }, // 158: Road Node 158
    { lat: 29.42966932, lon: 32.39883676 }, // 159: Road Node 159
    { lat: 29.42962683, lon: 32.39883531 }, // 160: Road Node 160
    { lat: 29.42955011, lon: 32.39884129 }, // 161: Road Node 161
    { lat: 29.42949867, lon: 32.39885137 }, // 162: Road Node 162
    { lat: 29.42945327, lon: 32.39885977 }, // 163: Road Node 163
    { lat: 29.42939174, lon: 32.39887650 }, // 164: Road Node 164
    { lat: 29.42933811, lon: 32.39889259 }, // 165: Road Node 165
    { lat: 29.42928317, lon: 32.39891440 }, // 166: Road Node 166
    { lat: 29.42923733, lon: 32.39893012 }, // 167: Road Node 167
    { lat: 29.42918425, lon: 32.39895531 }, // 168: Road Node 168
    { lat: 29.42913089, lon: 32.39898122 }, // 169: Road Node 169
    { lat: 29.42908429, lon: 32.39900589 }, // 170: Road Node 170
    { lat: 29.42904570, lon: 32.39902777 }, // 171: Road Node 171
    { lat: 29.42901320, lon: 32.39904740 }, // 172: Road Node 172
    { lat: 29.42898273, lon: 32.39907017 }, // 173: Road Node 173
    { lat: 29.42895825, lon: 32.39908560 }, // 174: Road Node 174
    { lat: 29.42892239, lon: 32.39910728 }, // 175: Road Node 175
    { lat: 29.42889584, lon: 32.39912581 }, // 176: Road Node 176
    { lat: 29.42887722, lon: 32.39913913 }, // 177: Road Node 177
    { lat: 29.42883126, lon: 32.39915815 }, // 178: Road Node 178
    { lat: 29.42878065, lon: 32.39916460 }, // 179: Road Node 179
    { lat: 29.42872549, lon: 32.39916156 }, // 180: Road Node 180
    { lat: 29.42870727, lon: 32.39915746 }, // 181: Roundabout Node 181
    { lat: 29.42868449, lon: 32.39912710 }, // 182: Roundabout Node 182
    { lat: 29.42865116, lon: 32.39910550 }, // 183: Roundabout Node 183
    { lat: 29.42861343, lon: 32.39909484 }, // 184: Roundabout Node 184
    { lat: 29.42858978, lon: 32.39909416 }, // 185: Roundabout Node 185
    { lat: 29.42855914, lon: 32.39909658 }, // 186: Roundabout Node 186
    { lat: 29.42852760, lon: 32.39910745 }, // 187: Roundabout Node 187
    { lat: 29.42849796, lon: 32.39912486 }, // 188: Roundabout Node 188
    { lat: 29.42846745, lon: 32.39914727 }, // 189: Roundabout Node 189
    { lat: 29.42844310, lon: 32.39916788 }, // 190: Roundabout Node 190
    { lat: 29.42842077, lon: 32.39919266 }, // 191: Roundabout Node 191
    { lat: 29.42839818, lon: 32.39922049 }, // 192: Roundabout Node 192
    { lat: 29.42838327, lon: 32.39924596 }, // 193: Roundabout Node 193
    { lat: 29.42836882, lon: 32.39927039 }, // 194: Roundabout Node 194
    { lat: 29.42835345, lon: 32.39930666 }, // 195: Roundabout Node 195
    { lat: 29.42834915, lon: 32.39932958 }, // 196: Roundabout Node 196
    { lat: 29.42834534, lon: 32.39936146 }, // 197: Roundabout Node 197
    { lat: 29.42834582, lon: 32.39939034 }, // 198: Roundabout Node 198
    { lat: 29.42834688, lon: 32.39941846 }, // 199: Roundabout Node 199
    { lat: 29.42835152, lon: 32.39944640 }, // 200: Roundabout Node 200
    { lat: 29.42836053, lon: 32.39947198 }, // 201: Roundabout Node 201
    { lat: 29.42837438, lon: 32.39949245 }, // 202: Roundabout Node 202
    { lat: 29.42839208, lon: 32.39950897 }, // 203: Roundabout Node 203
    { lat: 29.42840759, lon: 32.39951919 }, // 204: Roundabout Node 204
    { lat: 29.42842601, lon: 32.39952713 }, // 205: Roundabout Node 205
    { lat: 29.42845114, lon: 32.39953422 }, // 206: Roundabout Node 206
    { lat: 29.42847455, lon: 32.39953580 }, // 207: Roundabout Node 207
    { lat: 29.42850018, lon: 32.39953467 }, // 208: Roundabout Node 208
    { lat: 29.42852683, lon: 32.39953095 }, // 209: Roundabout Node 209
    { lat: 29.42854969, lon: 32.39951971 }, // 210: Roundabout Node 210
    { lat: 29.42858960, lon: 32.39948854 }, // 211: Roundabout Node 211
    { lat: 29.42862428, lon: 32.39945842 }, // 212: Roundabout Node 212
    { lat: 29.42865677, lon: 32.39941744 }, // 213: Roundabout Node 213
    { lat: 29.42868132, lon: 32.39938037 }, // 214: Roundabout Node 214
    { lat: 29.42870053, lon: 32.39934881 }, // 215: Roundabout Node 215
    { lat: 29.42871162, lon: 32.39932031 }, // 216: Roundabout Node 216
    { lat: 29.42871943, lon: 32.39928900 }, // 217: Roundabout Node 217
    { lat: 29.42872175, lon: 32.39925911 }, // 218: Roundabout Node 218
    { lat: 29.42872176, lon: 32.39923070 }, // 219: Roundabout Node 219
    { lat: 29.42872074, lon: 32.39920714 }, // 220: Roundabout Node 220
    { lat: 29.42871650, lon: 32.39918342 }, // 221: Roundabout Node 221
    { lat: 29.42839795, lon: 32.39955175 }, // 222: Road Node 222
    { lat: 29.42839859, lon: 32.39959809 }, // 223: Road Node 223
    { lat: 29.42839664, lon: 32.39963928 }, // 224: Road Node 224
    { lat: 29.42839270, lon: 32.39967838 }, // 225: Road Node 225
    { lat: 29.42837585, lon: 32.39972141 }, // 226: Road Node 226
    { lat: 29.42833799, lon: 32.39979889 }, // 227: Road Node 227
    { lat: 29.42831631, lon: 32.39985026 }, // 228: Road Node 228
    { lat: 29.42828938, lon: 32.39991435 }, // 229: Road Node 229
    { lat: 29.42826216, lon: 32.39998049 }, // 230: Road Node 230
    { lat: 29.42824013, lon: 32.40003728 }, // 231: Road Node 231
    { lat: 29.42822388, lon: 32.40008032 }, // 232: Road Node 232
    { lat: 29.42820745, lon: 32.40012891 }, // 233: Road Node 233
    { lat: 29.42819103, lon: 32.40018185 }, // 234: Road Node 234
    { lat: 29.42817398, lon: 32.40023459 }, // 235: Road Node 235
    { lat: 29.42815888, lon: 32.40029422 }, // 236: Road Node 236
    { lat: 29.42814886, lon: 32.40034921 }, // 237: Road Node 237
    { lat: 29.42813527, lon: 32.40042003 }, // 238: Road Node 238
    { lat: 29.42812494, lon: 32.40048064 }, // 239: Road Node 239
    { lat: 29.42811675, lon: 32.40054872 }, // 240: Road Node 240
    { lat: 29.42810961, lon: 32.40060517 }, // 241: Road Node 241
    { lat: 29.42810962, lon: 32.40067370 }, // 242: Road Node 242
    { lat: 29.42811099, lon: 32.40071661 }, // 243: Road Node 243
    { lat: 29.42811396, lon: 32.40076127 }, // 244: Road Node 244
    { lat: 29.42811876, lon: 32.40081082 }, // 245: Road Node 245
    { lat: 29.42813086, lon: 32.40086832 }, // 246: Road Node 246
    { lat: 29.42814871, lon: 32.40092618 }, // 247: Road Node 247
    { lat: 29.42816909, lon: 32.40098518 }, // 248: Road Node 248
    { lat: 29.42818904, lon: 32.40103326 }, // 249: Road Node 249
    { lat: 29.42820396, lon: 32.40111624 }, // 250: Spiked Bump 10
    { lat: 29.42820956, lon: 32.40117569 }, // 251: Road Node 251
    { lat: 29.42820103, lon: 32.40121567 }, // 252: Roundabout Node 252
    { lat: 29.42817624, lon: 32.40124507 }, // 253: Roundabout Node 253
    { lat: 29.42815132, lon: 32.40128738 }, // 254: Roundabout Node 254
    { lat: 29.42813981, lon: 32.40133406 }, // 255: Roundabout Node 255
    { lat: 29.42813512, lon: 32.40138985 }, // 256: Roundabout Node 256
    { lat: 29.42813982, lon: 32.40143383 }, // 257: Roundabout Node 257
    { lat: 29.42815005, lon: 32.40147529 }, // 258: Roundabout Node 258
    { lat: 29.42816440, lon: 32.40150895 }, // 259: Roundabout Node 259
    { lat: 29.42818469, lon: 32.40153385 }, // 260: Roundabout Node 260
    { lat: 29.42820707, lon: 32.40155428 }, // 261: Roundabout Node 261
    { lat: 29.42823224, lon: 32.40157323 }, // 262: Roundabout Node 262
    { lat: 29.42826806, lon: 32.40159236 }, // 263: Roundabout Node 263
    { lat: 29.42829544, lon: 32.40159799 }, // 264: Roundabout Node 264
    { lat: 29.42833152, lon: 32.40160301 }, // 265: Roundabout Node 265
    { lat: 29.42835704, lon: 32.40159862 }, // 266: Roundabout Node 266
    { lat: 29.42838789, lon: 32.40158848 }, // 267: Roundabout Node 267
    { lat: 29.42841799, lon: 32.40157407 }, // 268: Roundabout Node 268
    { lat: 29.42844604, lon: 32.40154749 }, // 269: Roundabout Node 269
    { lat: 29.42846741, lon: 32.40151196 }, // 270: Roundabout Node 270
    { lat: 29.42849198, lon: 32.40146972 }, // 271: Roundabout Node 271
    { lat: 29.42850019, lon: 32.40143143 }, // 272: Roundabout Node 272
    { lat: 29.42850182, lon: 32.40139502 }, // 273: Roundabout Node 273
    { lat: 29.42849980, lon: 32.40136094 }, // 274: Roundabout Node 274
    { lat: 29.42849404, lon: 32.40132906 }, // 275: Roundabout Node 275
    { lat: 29.42848248, lon: 32.40129264 }, // 276: Roundabout Node 276
    { lat: 29.42845714, lon: 32.40125500 }, // 277: Roundabout Node 277
    { lat: 29.42842268, lon: 32.40122972 }, // 278: Roundabout Node 278
    { lat: 29.42838327, lon: 32.40120591 }, // 279: Roundabout Node 279
    { lat: 29.42834380, lon: 32.40119484 }, // 280: Roundabout Node 280
    { lat: 29.42830053, lon: 32.40118719 }, // 281: Roundabout Node 281
    { lat: 29.42826347, lon: 32.40119290 }, // 282: Roundabout Node 282
    { lat: 29.42823525, lon: 32.40120177 }, // 283: Roundabout Node 283
    { lat: 29.42814645, lon: 32.40153748 }, // 284: Road Node 284
    { lat: 29.42813440, lon: 32.40158125 }, // 285: Road Node 285
    { lat: 29.42811261, lon: 32.40162347 }, // 286: Road Node 286
    { lat: 29.42808516, lon: 32.40166870 }, // 287: Road Node 287
    { lat: 29.42796127, lon: 32.40186197 }, // 288: Pharmacy Station (Node 288)
    { lat: 29.42784736, lon: 32.40202995 }, // 289: Pharmacy Station (Node 289)
    { lat: 29.42770783, lon: 32.40224199 }, // 290: Road Node 290
    { lat: 29.42754195, lon: 32.40248987 }, // 291: Reg Bump 9
    { lat: 29.42739400, lon: 32.40271556 }, // 292: Nursing Station (Node 292)
    { lat: 29.42724215, lon: 32.40294103 }, // 293: Road Node 293
    { lat: 29.42708905, lon: 32.40317171 }, // 294: Road Node 294
    { lat: 29.42698531, lon: 32.40331822 }, // 295: Road Node 295
    { lat: 29.42693022, lon: 32.40339359 }, // 296: Road Node 296
    { lat: 29.42687864, lon: 32.40345543 }, // 297: Road Node 297
    { lat: 29.42683288, lon: 32.40350388 }, // 298: Road Node 298
    { lat: 29.42678835, lon: 32.40355199 }, // 299: Road Node 299
    { lat: 29.42673339, lon: 32.40360287 }, // 300: Road Node 300
    { lat: 29.42665986, lon: 32.40366230 }, // 301: Spiked Bump 11
    { lat: 29.42660981, lon: 32.40369548 }, // 302: Road Node 302
    { lat: 29.42657454, lon: 32.40371430 }, // 303: Road Node 303
    { lat: 29.42654323, lon: 32.40371427 }, // 304: Roundabout Node 304
    { lat: 29.42651175, lon: 32.40371311 }, // 305: Roundabout Node 305
    { lat: 29.42647105, lon: 32.40369775 }, // 306: Roundabout Node 306
    { lat: 29.42644248, lon: 32.40369645 }, // 307: Roundabout Node 307
    { lat: 29.42641602, lon: 32.40370130 }, // 308: Roundabout Node 308
    { lat: 29.42638350, lon: 32.40371258 }, // 309: Roundabout Node 309
    { lat: 29.42634892, lon: 32.40373936 }, // 310: Roundabout Node 310
    { lat: 29.42632721, lon: 32.40376821 }, // 311: Roundabout Node 311
    { lat: 29.42630979, lon: 32.40380131 }, // 312: Roundabout Node 312
    { lat: 29.42629410, lon: 32.40384528 }, // 313: Roundabout Node 313
    { lat: 29.42629166, lon: 32.40388472 }, // 314: Roundabout Node 314
    { lat: 29.42629941, lon: 32.40392253 }, // 315: Roundabout Node 315
    { lat: 29.42631154, lon: 32.40395974 }, // 316: Roundabout Node 316
    { lat: 29.42632549, lon: 32.40399043 }, // 317: Roundabout Node 317
    { lat: 29.42634483, lon: 32.40401459 }, // 318: Roundabout Node 318
    { lat: 29.42636762, lon: 32.40402971 }, // 319: Roundabout Node 319
    { lat: 29.42639539, lon: 32.40404512 }, // 320: Roundabout Node 320
    { lat: 29.42641669, lon: 32.40405226 }, // 321: Medical Station (Node 321)
    { lat: 29.42644014, lon: 32.40405590 }, // 322: Medical Station (Node 322)
    { lat: 29.42646772, lon: 32.40405242 }, // 323: Medical Station (Node 323)
    { lat: 29.42649439, lon: 32.40404692 }, // 324: Medical Station (Node 324)
    { lat: 29.42652169, lon: 32.40403077 }, // 325: Medical Station (Node 325)
    { lat: 29.42654577, lon: 32.40400374 }, // 326: Medical Station (Node 326)
    { lat: 29.42656959, lon: 32.40396903 }, // 327: Medical Station (Node 327)
    { lat: 29.42658185, lon: 32.40394575 }, // 328: Medical Station (Node 328)
    { lat: 29.42659324, lon: 32.40391264 }, // 329: Medical Station (Node 329)
    { lat: 29.42659987, lon: 32.40388355 }, // 330: Medical Station (Node 330)
    { lat: 29.42660014, lon: 32.40386176 }, // 331: Medical Station (Node 331)
    { lat: 29.42659853, lon: 32.40383329 }, // 332: Medical Station (Node 332)
    { lat: 29.42658817, lon: 32.40380244 }, // 333: Roundabout Node 333
    { lat: 29.42657354, lon: 32.40377145 }, // 334: Roundabout Node 334
    { lat: 29.42655797, lon: 32.40374851 }, // 335: Roundabout Node 335
    { lat: 29.42646660, lon: 32.40408199 }, // 336: Medical Station (Node 336)
    { lat: 29.42649551, lon: 32.40411815 }, // 337: Medical Station (Node 337)
    { lat: 29.42651477, lon: 32.40414978 }, // 338: Medical Station (Node 338)
    { lat: 29.42653558, lon: 32.40419522 }, // 339: Medical Station (Node 339)
    { lat: 29.42655321, lon: 32.40424163 }, // 340: Medical Station (Node 340)
    { lat: 29.42656740, lon: 32.40428390 }, // 341: Road Node 341
    { lat: 29.42658331, lon: 32.40432735 }, // 342: Road Node 342
    { lat: 29.42659646, lon: 32.40436343 }, // 343: Road Node 343
    { lat: 29.42660684, lon: 32.40439276 }, // 344: Road Node 344
    { lat: 29.42661932, lon: 32.40442210 }, // 345: Road Node 345
    { lat: 29.42663293, lon: 32.40445482 }, // 346: Road Node 346
    { lat: 29.42664842, lon: 32.40448757 }, // 347: Road Node 347
    { lat: 29.42666695, lon: 32.40452299 }, // 348: Road Node 348
    { lat: 29.42668223, lon: 32.40455203 }, // 349: Road Node 349
    { lat: 29.42670658, lon: 32.40458816 }, // 350: Road Node 350
    { lat: 29.42673673, lon: 32.40462655 }, // 351: Road Node 351
    { lat: 29.42675658, lon: 32.40464944 }, // 352: Road Node 352
    { lat: 29.42677575, lon: 32.40467294 }, // 353: Road Node 353
    { lat: 29.42679895, lon: 32.40470027 }, // 354: Road Node 354
    { lat: 29.42681970, lon: 32.40472315 }, // 355: Road Node 355
    { lat: 29.42686409, lon: 32.40477322 }, // 356: Road Node 356
    { lat: 29.42689075, lon: 32.40480252 }, // 357: Road Node 357
    { lat: 29.42692939, lon: 32.40484675 }, // 358: Road Node 358
    { lat: 29.42695864, lon: 32.40487815 }, // 359: Road Node 359
    { lat: 29.42699348, lon: 32.40491916 }, // 360: Road Node 360
    { lat: 29.42704056, lon: 32.40497385 }, // 361: Road Node 361
    { lat: 29.42710273, lon: 32.40504999 }, // 362: Road Node 362
    { lat: 29.42720766, lon: 32.40517251 }, // 363: Road Node 363
    { lat: 29.42729766, lon: 32.40527141 }, // 364: Road Node 364
    { lat: 29.42740217, lon: 32.40538871 }, // 365: Road Node 365
    { lat: 29.42749193, lon: 32.40548861 }, // 366: Road Node 366
    { lat: 29.42754453, lon: 32.40555034 }, // 367: Road Node 367
    { lat: 29.42760512, lon: 32.40561733 }, // 368: Road Node 368
    { lat: 29.42766738, lon: 32.40568936 }, // 369: Road Node 369
    { lat: 29.42776274, lon: 32.40579664 }, // 370: Turn Corner2 Node 370
    { lat: 29.42781671, lon: 32.40586155 }, // 371: Turn Corner2 Node 371
    { lat: 29.42786830, lon: 32.40591697 }, // 372: Turn Corner2 Node 372
    { lat: 29.42789440, lon: 32.40593354 }, // 373: Turn Corner2 Node 373
    { lat: 29.42792555, lon: 32.40594460 }, // 374: Turn Corner2 Node 374
    { lat: 29.42795230, lon: 32.40594871 }, // 375: Turn Corner2 Node 375
    { lat: 29.42798809, lon: 32.40594644 }, // 376: Turn Corner2 Node 376
    { lat: 29.42801773, lon: 32.40594224 }, // 377: Turn Corner2 Node 377
    { lat: 29.42804608, lon: 32.40593413 }, // 378: Turn Corner2 Node 378
    { lat: 29.42806913, lon: 32.40592300 }, // 379: Turn Corner2 Node 379
    { lat: 29.42809580, lon: 32.40590460 }, // 380: Turn Corner2 Node 380
    { lat: 29.42812888, lon: 32.40587113 }, // 381: Turn Corner2 Node 381
    { lat: 29.42815438, lon: 32.40584166 }, // 382: Turn Corner2 Node 382
    { lat: 29.42817949, lon: 32.40580667 }, // 383: Reg Bump 4
    { lat: 29.42822707, lon: 32.40574478 }, // 384: Dentistry Station (Node 384)
    { lat: 29.42826372, lon: 32.40569520 }, // 385: Dentistry Station (Node 385)
    { lat: 29.42829660, lon: 32.40564928 }, // 386: Dentistry Station (Node 386)
    { lat: 29.42833477, lon: 32.40559378 }, // 387: Dentistry Station (Node 387)
    { lat: 29.42837011, lon: 32.40554209 }, // 388: Dentistry Station (Node 388)
    { lat: 29.42843097, lon: 32.40545625 }, // 389: Dentistry Station (Node 389)
    { lat: 29.42847473, lon: 32.40539316 }, // 390: Road Node 390
    { lat: 29.42852920, lon: 32.40531335 }, // 391: Road Node 391
    { lat: 29.42857442, lon: 32.40524325 }, // 392: Road Node 392
    { lat: 29.42862942, lon: 32.40516129 }, // 393: Road Node 393
    { lat: 29.42869505, lon: 32.40506023 }, // 394: Road Node 394
    { lat: 29.42875564, lon: 32.40496937 }, // 395: Road Node 395
    { lat: 29.42881228, lon: 32.40488207 }, // 396: Road Node 396
    { lat: 29.42886440, lon: 32.40480659 }, // 397: Road Node 397
    { lat: 29.42892034, lon: 32.40472344 }, // 398: Road Node 398
    { lat: 29.42897518, lon: 32.40464545 }, // 399: Road Node 399
    { lat: 29.42903249, lon: 32.40456509 }, // 400: Road Node 400
    { lat: 29.42911350, lon: 32.40444853 }, // 401: Road Node 401
    { lat: 29.42919450, lon: 32.40433172 }, // 402: Physical Therapy Station (Node 402)
    { lat: 29.42925343, lon: 32.40424369 }, // 403: Physical Therapy Station (Node 403)
    { lat: 29.42932714, lon: 32.40413575 }, // 404: Physical Therapy Station (Node 404)
    { lat: 29.42939127, lon: 32.40403715 }, // 405: Physical Therapy Station (Node 405)
    { lat: 29.42944706, lon: 32.40395213 }, // 406: Road Node 406
    { lat: 29.42949888, lon: 32.40387871 }, // 407: Road Node 407
    { lat: 29.42954491, lon: 32.40381340 }, // 408: Road Node 408
    { lat: 29.42962036, lon: 32.40371353 }, // 409: Road Node 409
    { lat: 29.42966999, lon: 32.40364850 }, // 410: Road Node 410
    { lat: 29.42972422, lon: 32.40357132 }, // 411: Road Node 411
    { lat: 29.42979496, lon: 32.40346923 }, // 412: Road Node 412
    { lat: 29.42988783, lon: 32.40333857 }, // 413: Applied Health Station (Node 413)
    { lat: 29.42996975, lon: 32.40322360 }, // 414: Applied Health Station (Node 414)
    { lat: 29.43003750, lon: 32.40313742 }, // 415: Applied Health Station (Node 415)
    { lat: 29.43010402, lon: 32.40304742 }, // 416: Applied Health Station (Node 416)
    { lat: 29.43019735, lon: 32.40291783 }, // 417: Road Node 417
    { lat: 29.43027170, lon: 32.40281426 }, // 418: Road Node 418
    { lat: 29.43033822, lon: 32.40272283 }, // 419: Road Node 419
    { lat: 29.43039250, lon: 32.40265251 }, // 420: Road Node 420
    { lat: 29.43048046, lon: 32.40252638 }, // 421: Road Node 421
    { lat: 29.43058724, lon: 32.40237711 }, // 422: Road Node 422
    { lat: 29.43065518, lon: 32.40228227 }, // 423: Road Node 423
    { lat: 29.43073180, lon: 32.40217917 }, // 424: Road Node 424
    { lat: 29.43082925, lon: 32.40205429 }, // 425: Road Node 425
    { lat: 29.43092738, lon: 32.40193255 }, // 426: Road Node 426
    { lat: 29.43107240, lon: 32.40176072 }, // 427: Admission Station (Node 427)
    { lat: 29.43115126, lon: 32.40165380 }, // 428: Admission Station (Node 428)
    { lat: 29.43079556, lon: 32.40205132 }, // 429: Road Node 429
    { lat: 29.43075410, lon: 32.40210289 }, // 430: Road Node 430
    { lat: 29.43067317, lon: 32.40220853 }, // 431: Road Node 431
    { lat: 29.43062088, lon: 32.40228529 }, // 432: Road Node 432
    { lat: 29.43053106, lon: 32.40240724 }, // 433: Road Node 433
    { lat: 29.43044686, lon: 32.40252938 }, // 434: Road Node 434
    { lat: 29.43038226, lon: 32.40261571 }, // 435: Road Node 435
    { lat: 29.43031730, lon: 32.40271032 }, // 436: Road Node 436
    { lat: 29.43026111, lon: 32.40278528 }, // 437: Road Node 437
    { lat: 29.43019446, lon: 32.40287930 }, // 438: Road Node 438
    { lat: 29.43012707, lon: 32.40296419 }, // 439: Road Node 439
    { lat: 29.43006463, lon: 32.40305309 }, // 440: Applied Health Station (Node 440)
    { lat: 29.42998180, lon: 32.40316778 }, // 441: Applied Health Station (Node 441)
    { lat: 29.42990349, lon: 32.40326752 }, // 442: Applied Health Station (Node 442)
    { lat: 29.42981520, lon: 32.40339274 }, // 443: Road Node 443
    { lat: 29.42971065, lon: 32.40353947 }, // 444: Road Node 444
    { lat: 29.42962150, lon: 32.40365938 }, // 445: Road Node 445
    { lat: 29.42954237, lon: 32.40377487 }, // 446: Road Node 446
    { lat: 29.42947358, lon: 32.40386623 }, // 447: Road Node 447
    { lat: 29.42937434, lon: 32.40401921 }, // 448: Physical Therapy Station (Node 448)
    { lat: 29.42928356, lon: 32.40415616 }, // 449: Physical Therapy Station (Node 449)
    { lat: 29.42922295, lon: 32.40424358 }, // 450: Physical Therapy Station (Node 450)
    { lat: 29.42904986, lon: 32.40449120 }, // 451: Road Node 451
    { lat: 29.42896300, lon: 32.40461368 }, // 452: Road Node 452
    { lat: 29.42888254, lon: 32.40473681 }, // 453: Road Node 453
    { lat: 29.42878990, lon: 32.40487455 }, // 454: Road Node 454
    { lat: 29.42868883, lon: 32.40502020 }, // 455: Road Node 455
    { lat: 29.42859791, lon: 32.40515836 }, // 456: Road Node 456
    { lat: 29.42852964, lon: 32.40525991 }, // 457: Road Node 457
    { lat: 29.42844828, lon: 32.40537963 }, // 458: Road Node 458
    { lat: 29.42836383, lon: 32.40550296 }, // 459: Dentistry Station (Node 459)
    { lat: 29.42828960, lon: 32.40561523 }, // 460: Dentistry Station (Node 460)
    { lat: 29.42821244, lon: 32.40572487 }, // 461: Dentistry Station (Node 461)
    { lat: 29.42814211, lon: 32.40582287 }, // 462: Road Node 462
    { lat: 29.42811414, lon: 32.40585580 }, // 463: Road Node 463
    { lat: 29.42808516, lon: 32.40587954 }, // 464: Road Node 464
    { lat: 29.42804787, lon: 32.40590263 }, // 465: Road Node 465
    { lat: 29.42800541, lon: 32.40591519 }, // 466: Road Node 466
    { lat: 29.42796549, lon: 32.40591403 }, // 467: Road Node 467
    { lat: 29.42793310, lon: 32.40590787 }, // 468: Road Node 468
    { lat: 29.42790822, lon: 32.40589834 }, // 469: Road Node 469
    { lat: 29.42788821, lon: 32.40588697 }, // 470: Road Node 470
    { lat: 29.42786724, lon: 32.40587058 }, // 471: Road Node 471
    { lat: 29.42783984, lon: 32.40584636 }, // 472: Road Node 472
    { lat: 29.42782165, lon: 32.40582602 }, // 473: Road Node 473
    { lat: 29.42779516, lon: 32.40579630 }, // 474: Reg Bump 5
    { lat: 29.42777121, lon: 32.40577107 }, // 475: Road Node 475
    { lat: 29.42774815, lon: 32.40574652 }, // 476: Road Node 476
    { lat: 29.42772403, lon: 32.40571665 }, // 477: Road Node 477
    { lat: 29.42769531, lon: 32.40568471 }, // 478: Road Node 478
    { lat: 29.42766595, lon: 32.40565418 }, // 479: Road Node 479
    { lat: 29.42760966, lon: 32.40559178 }, // 480: Road Node 480
    { lat: 29.42757966, lon: 32.40555752 }, // 481: Road Node 481
    { lat: 29.42755196, lon: 32.40552331 }, // 482: Road Node 482
    { lat: 29.42752211, lon: 32.40548915 }, // 483: Road Node 483
    { lat: 29.42748357, lon: 32.40544800 }, // 484: Road Node 484
    { lat: 29.42745472, lon: 32.40541218 }, // 485: Road Node 485
    { lat: 29.42736881, lon: 32.40531337 }, // 486: Road Node 486
    { lat: 29.42728676, lon: 32.40521796 }, // 487: Road Node 487
    { lat: 29.42722517, lon: 32.40514511 }, // 488: Road Node 488
    { lat: 29.42716493, lon: 32.40507803 }, // 489: Road Node 489
    { lat: 29.42709541, lon: 32.40500114 }, // 490: Road Node 490
    { lat: 29.42702328, lon: 32.40491441 }, // 491: Road Node 491
    { lat: 29.42694621, lon: 32.40482906 }, // 492: Road Node 492
    { lat: 29.42687233, lon: 32.40474668 }, // 493: Road Node 493
    { lat: 29.42681905, lon: 32.40468136 }, // 494: Road Node 494
    { lat: 29.42676506, lon: 32.40461834 }, // 495: Road Node 495
    { lat: 29.42671047, lon: 32.40454911 }, // 496: Road Node 496
    { lat: 29.42667181, lon: 32.40447610 }, // 497: Road Node 497
    { lat: 29.42664271, lon: 32.40441143 }, // 498: Road Node 498
    { lat: 29.42660984, lon: 32.40432518 }, // 499: Road Node 499
    { lat: 29.42658713, lon: 32.40426804 }, // 500: Road Node 500
    { lat: 29.42655457, lon: 32.40416349 }, // 501: Medical Station (Node 501)
    { lat: 29.42653732, lon: 32.40410730 }, // 502: Medical Station (Node 502)
    { lat: 29.42653801, lon: 32.40406899 }, // 503: Medical Station (Node 503)
    { lat: 29.42662262, lon: 32.40382923 }, // 504: Medical Station (Node 504)
    { lat: 29.42663912, lon: 32.40380233 }, // 505: Road Node 505
    { lat: 29.42666534, lon: 32.40376846 }, // 506: Road Node 506
    { lat: 29.42669689, lon: 32.40373919 }, // 507: Road Node 507
    { lat: 29.42672652, lon: 32.40371395 }, // 508: Road Node 508
    { lat: 29.42676832, lon: 32.40367576 }, // 509: Road Node 509
    { lat: 29.42681843, lon: 32.40362517 }, // 510: Road Node 510
    { lat: 29.42687776, lon: 32.40356554 }, // 511: Road Node 511
    { lat: 29.42693369, lon: 32.40350263 }, // 512: Road Node 512
    { lat: 29.42699698, lon: 32.40342390 }, // 513: Road Node 513
    { lat: 29.42703849, lon: 32.40336927 }, // 514: Road Node 514
    { lat: 29.42707901, lon: 32.40331167 }, // 515: Road Node 515
    { lat: 29.42715684, lon: 32.40320093 }, // 516: Road Node 516
    { lat: 29.42720967, lon: 32.40312085 }, // 517: Road Node 517
    { lat: 29.42729065, lon: 32.40300200 }, // 518: Nursing Station (Node 518)
    { lat: 29.42736469, lon: 32.40289530 }, // 519: Nursing Station (Node 519)
    { lat: 29.42742306, lon: 32.40280592 }, // 520: Nursing Station (Node 520)
    { lat: 29.42748216, lon: 32.40271330 }, // 521: Nursing Station (Node 521)
    { lat: 29.42758047, lon: 32.40255976 }, // 522: Road Node 522
    { lat: 29.42768757, lon: 32.40239804 }, // 523: Road Node 523
    { lat: 29.42779043, lon: 32.40224258 }, // 524: Road Node 524
    { lat: 29.42786636, lon: 32.40213122 }, // 525: Pharmacy Station (Node 525)
    { lat: 29.42794260, lon: 32.40201435 }, // 526: Pharmacy Station (Node 526)
    { lat: 29.42801924, lon: 32.40190099 }, // 527: Pharmacy Station (Node 527)
    { lat: 29.42807931, lon: 32.40181549 }, // 528: Pharmacy Station (Node 528)
    { lat: 29.42815731, lon: 32.40170518 }, // 529: Road Node 529
    { lat: 29.42821728, lon: 32.40164609 }, // 530: Spiked Bump 9
    { lat: 29.42827131, lon: 32.40162256 }, // 531: Road Node 531
    { lat: 29.42831120, lon: 32.40160959 }, // 532: Road Node 532
    { lat: 29.42852632, lon: 32.40142987 }, // 533: Road Node 533
    { lat: 29.42856561, lon: 32.40140978 }, // 534: Road Node 534
    { lat: 29.42860591, lon: 32.40139573 }, // 535: Road Node 535
    { lat: 29.42865254, lon: 32.40139087 }, // 536: Road Node 536
    { lat: 29.42876121, lon: 32.40138087 }, // 537: Road Node 537
    { lat: 29.42882831, lon: 32.40137632 }, // 538: Road Node 538
    { lat: 29.42894129, lon: 32.40135114 }, // 539: Road Node 539
    { lat: 29.42908214, lon: 32.40130802 }, // 540: Road Node 540
    { lat: 29.42920301, lon: 32.40125051 }, // 541: Road Node 541
    { lat: 29.42937485, lon: 32.40115803 }, // 542: Road Node 542
    { lat: 29.42948849, lon: 32.40107782 }, // 543: Road Node 543
    { lat: 29.42958723, lon: 32.40099788 }, // 544: Road Node 544
    { lat: 29.42967558, lon: 32.40090982 }, // 545: Reg Bump 12
    { lat: 29.42977161, lon: 32.40080338 }, // 546: Road Node 546
    { lat: 29.42983324, lon: 32.40072767 }, // 547: Road Node 547
    { lat: 29.42991969, lon: 32.40060570 }, // 548: Road Node 548
    { lat: 29.42998426, lon: 32.40049927 }, // 549: Road Node 549
    { lat: 29.43003691, lon: 32.40040429 }, // 550: Road Node 550
    { lat: 29.43008497, lon: 32.40029597 }, // 551: Road Node 551
    { lat: 29.43014334, lon: 32.40014765 }, // 552: Road Node 552
    { lat: 29.43018389, lon: 32.40000735 }, // 553: Road Node 553
    { lat: 29.43021318, lon: 32.39987204 }, // 554: Road Node 554
    { lat: 29.43023914, lon: 32.39969465 }, // 555: Road Node 555
    { lat: 29.43025190, lon: 32.39953710 }, // 556: CS & Eng Station (Node 556)
    { lat: 29.43024508, lon: 32.39937072 }, // 557: CS & Eng Station (Node 557)
    { lat: 29.43022445, lon: 32.39926706 }, // 558: CS & Eng Station (Node 558)
    { lat: 29.43022485, lon: 32.39918450 }, // 559: CS & Eng Station (Node 559)
    { lat: 29.43024192, lon: 32.39913879 }, // 560: CS & Eng Station (Node 560)
    { lat: 29.43027212, lon: 32.39909086 }, // 561: Road Node 561
    { lat: 29.43034162, lon: 32.39881113 }, // 562: Road Node 562
    { lat: 29.43036048, lon: 32.39876421 }, // 563: Road Node 563
    { lat: 29.43040411, lon: 32.39870613 }, // 564: Reg Bump 18
    { lat: 29.43046114, lon: 32.39863522 }, // 565: Road Node 565
    { lat: 29.43051921, lon: 32.39856649 }, // 566: Road Node 566
    { lat: 29.43059681, lon: 32.39848199 }, // 567: Road Node 567
    { lat: 29.43069644, lon: 32.39836288 }, // 568: Road Node 568
    { lat: 29.43078142, lon: 32.39826189 }, // 569: Road Node 569
    { lat: 29.43088013, lon: 32.39814868 }, // 570: Road Node 570
    { lat: 29.43095617, lon: 32.39806164 }, // 571: Road Node 571
    { lat: 29.43106280, lon: 32.39793669 }, // 572: Spiked Bump 4
    { lat: 29.43116648, lon: 32.39781747 }, // 573: Road Node 573
    { lat: 29.43127799, lon: 32.39768850 }, // 574: Road Node 574
    { lat: 29.43138897, lon: 32.39755634 }, // 575: Road Node 575
    { lat: 29.43152286, lon: 32.39739194 }, // 576: Road Node 576
    { lat: 29.43164681, lon: 32.39724097 }, // 577: Road Node 577
    { lat: 29.43174167, lon: 32.39712318 }, // 578: Road Node 578
    { lat: 29.43182338, lon: 32.39702449 }, // 579: Road Node 579
    { lat: 29.43188450, lon: 32.39695162 }, // 580: Reg Bump 20
    { lat: 29.43194685, lon: 32.39687502 }, // 581: Road Node 581
    { lat: 29.43197581, lon: 32.39685005 }, // 582: Spiked Bump 6
    { lat: 29.43199959, lon: 32.39683251 }, // 583: Road Node 583
    { lat: 29.43203333, lon: 32.39681642 }, // 584: Road Node 584
    { lat: 29.43206039, lon: 32.39680841 }, // 585: Road Node 585
    { lat: 29.43235251, lon: 32.39674222 }, // 586: Road Node 586
    { lat: 29.43239040, lon: 32.39674202 }, // 587: Road Node 587
    { lat: 29.43242378, lon: 32.39675231 }, // 588: Road Node 588
    { lat: 29.43245656, lon: 32.39676854 }, // 589: Road Node 589
    { lat: 29.43249261, lon: 32.39678474 }, // 590: Road Node 590
    { lat: 29.43254150, lon: 32.39680831 }, // 591: Road Node 591
    { lat: 29.43257984, lon: 32.39682664 }, // 592: Road Node 592
    { lat: 29.43262669, lon: 32.39685221 }, // 593: Road Node 593
    { lat: 29.43267692, lon: 32.39688474 }, // 594: Road Node 594
    { lat: 29.43271970, lon: 32.39691592 }, // 595: Road Node 595
    { lat: 29.43275811, lon: 32.39694154 }, // 596: Arts & Design Station (Node 596)
    { lat: 29.43279507, lon: 32.39697364 }, // 597: Arts & Design Station (Node 597)
    { lat: 29.43282870, lon: 32.39700626 }, // 598: Arts & Design Station (Node 598)
    { lat: 29.43285222, lon: 32.39703265 }, // 599: Arts & Design Station (Node 599)
    { lat: 29.43288092, lon: 32.39706283 }, // 600: Arts & Design Station (Node 600)
    { lat: 29.43292068, lon: 32.39710787 }, // 601: Arts & Design Station (Node 601)
    { lat: 29.43298051, lon: 32.39717270 }, // 602: Arts & Design Station (Node 602)
    { lat: 29.43302264, lon: 32.39721390 }, // 603: Arts & Design Station (Node 603)
    { lat: 29.43305357, lon: 32.39724751 }, // 604: Road Node 604
    { lat: 29.43309579, lon: 32.39729710 }, // 605: Road Node 605
    { lat: 29.43313828, lon: 32.39734186 }, // 606: Road Node 606
    { lat: 29.43319774, lon: 32.39741035 }, // 607: Road Node 607
    { lat: 29.43324178, lon: 32.39745981 }, // 608: Road Node 608
    { lat: 29.43329266, lon: 32.39751339 }, // 609: Road Node 609
    { lat: 29.43333813, lon: 32.39756603 }, // 610: Road Node 610
    { lat: 29.43337701, lon: 32.39760971 }, // 611: Road Node 611
    { lat: 29.43342150, lon: 32.39765081 }, // 612: Engineering Station (Node 612)
    { lat: 29.43347617, lon: 32.39771058 }, // 613: Engineering Station (Node 613)
    { lat: 29.43349117, lon: 32.39774832 }, // 614: Engineering Station (Node 614)
    { lat: 29.43351948, lon: 32.39778087 }, // 615: Engineering Station (Node 615)
    { lat: 29.43355847, lon: 32.39782279 }, // 616: Engineering Station (Node 616)
    { lat: 29.43359937, lon: 32.39786689 }, // 617: Engineering Station (Node 617)
    { lat: 29.43363570, lon: 32.39791041 }, // 618: Engineering Station (Node 618)
    { lat: 29.43367773, lon: 32.39796172 }, // 619: Engineering Station (Node 619)
    { lat: 29.43371557, lon: 32.39800413 }, // 620: Road Node 620
    { lat: 29.43374102, lon: 32.39803126 }, // 621: Road Node 621
    { lat: 29.43377172, lon: 32.39807386 }, // 622: Road Node 622
    { lat: 29.43378942, lon: 32.39810509 }, // 623: Road Node 623
    { lat: 29.43380090, lon: 32.39813519 }, // 624: Road Node 624
    { lat: 29.43380826, lon: 32.39816936 }, // 625: Road Node 625
    { lat: 29.43381286, lon: 32.39820052 }, // 626: Road Node 626
    { lat: 29.43381449, lon: 32.39822980 }, // 627: Road Node 627
    { lat: 29.43380812, lon: 32.39826703 }, // 628: Road Node 628
    { lat: 29.43380267, lon: 32.39829816 }, // 629: Road Node 629
    { lat: 29.43379080, lon: 32.39833205 }, // 630: Road Node 630
    { lat: 29.43377248, lon: 32.39837029 }, // 631: Road Node 631
    { lat: 29.43373936, lon: 32.39841374 }, // 632: Reg Bump 2
    { lat: 29.43369119, lon: 32.39846428 }, // 633: Road Node 633
    { lat: 29.43364440, lon: 32.39851834 }, // 634: Road Node 634
    { lat: 29.43360883, lon: 32.39856022 }, // 635: Road Node 635
    { lat: 29.43357135, lon: 32.39860063 }, // 636: Road Node 636
    { lat: 29.43353059, lon: 32.39864322 }, // 637: Road Node 637
    { lat: 29.43346032, lon: 32.39872502 }, // 638: Road Node 638
    { lat: 29.43339381, lon: 32.39880603 }, // 639: Road Node 639
    { lat: 29.43333645, lon: 32.39886986 }, // 640: Road Node 640
    { lat: 29.43327399, lon: 32.39893748 }, // 641: Road Node 641
    { lat: 29.43320948, lon: 32.39900985 }, // 642: Road Node 642
    { lat: 29.43314509, lon: 32.39907769 }, // 643: Road Node 643
    { lat: 29.43308386, lon: 32.39914351 }, // 644: Road Node 644
    { lat: 29.43302402, lon: 32.39920818 }, // 645: Road Node 645
    { lat: 29.43294314, lon: 32.39929192 }, // 646: Road Node 646
    { lat: 29.43288077, lon: 32.39936140 }, // 647: Road Node 647
    { lat: 29.43282439, lon: 32.39941931 }, // 648: Road Node 648
    { lat: 29.43276847, lon: 32.39947934 }, // 649: Road Node 649
    { lat: 29.43272647, lon: 32.39952763 }, // 650: Road Node 650
    { lat: 29.43267612, lon: 32.39958602 }, // 651: Road Node 651
    { lat: 29.43263212, lon: 32.39963428 }, // 652: Road Node 652
    { lat: 29.43258028, lon: 32.39969206 }, // 653: Road Node 653
    { lat: 29.43252913, lon: 32.39975747 }, // 654: Road Node 654
    { lat: 29.43246694, lon: 32.39983798 }, // 655: Road Node 655
    { lat: 29.43241515, lon: 32.39990548 }, // 656: Road Node 656
    { lat: 29.43237115, lon: 32.39996162 }, // 657: Road Node 657
    { lat: 29.43229891, lon: 32.40004941 }, // 658: Road Node 658
    { lat: 29.43221663, lon: 32.40015324 }, // 659: Road Node 659
    { lat: 29.43215972, lon: 32.40022942 }, // 660: Road Node 660
    { lat: 29.43209958, lon: 32.40030956 }, // 661: Road Node 661
    { lat: 29.43205367, lon: 32.40036918 }, // 662: Road Node 662
    { lat: 29.43199228, lon: 32.40044346 }, // 663: Science Station (Node 663)
    { lat: 29.43192535, lon: 32.40053784 }, // 664: Science Station (Node 664)
    { lat: 29.43187730, lon: 32.40059634 }, // 665: Science Station (Node 665)
    { lat: 29.43176336, lon: 32.40074979 }, // 666: Road Node 666
    { lat: 29.43169668, lon: 32.40083369 }, // 667: Road Node 667
    { lat: 29.43162532, lon: 32.40092748 }, // 668: Road Node 668
    { lat: 29.43154656, lon: 32.40102428 }, // 669: Road Node 669
    { lat: 29.43148286, lon: 32.40111522 }, // 670: Road Node 670
    { lat: 29.43140152, lon: 32.40122235 }, // 671: Road Node 671
    { lat: 29.43132875, lon: 32.40132830 }, // 672: Road Node 672
    { lat: 29.43125751, lon: 32.40142301 }, // 673: Road Node 673
    { lat: 29.43118721, lon: 32.40153167 }, // 674: Admission Station (Node 674)
    { lat: 29.43107812, lon: 32.40167970 }, // 675: Admission Station (Node 675)
    { lat: 29.43101090, lon: 32.40177829 }, // 676: Admission Station (Node 676)
    { lat: 29.43097698, lon: 32.40185004 }, // 677: Admission Station (Node 677)
    { lat: 29.43087474, lon: 32.40197356 }, // 678: Road Node 678
    { lat: 29.43084128, lon: 32.40201683 }, // 679: Road Node 679
    { lat: 29.43081376, lon: 32.40203863 }, // 680: Road Node 680
    { lat: 29.42837547, lon: 32.40118353 }, // 681: Road Node 681
    { lat: 29.42833980, lon: 32.40113254 }, // 682: Road Node 682
    { lat: 29.42829900, lon: 32.40107085 }, // 683: Road Node 683
    { lat: 29.42826520, lon: 32.40100111 }, // 684: Road Node 684
    { lat: 29.42822077, lon: 32.40089837 }, // 685: Road Node 685
    { lat: 29.42820330, lon: 32.40081578 }, // 686: Road Node 686
    { lat: 29.42819033, lon: 32.40070607 }, // 687: Road Node 687
    { lat: 29.42819612, lon: 32.40059954 }, // 688: Road Node 688
    { lat: 29.42819797, lon: 32.40050797 }, // 689: Road Node 689
    { lat: 29.42820706, lon: 32.40042612 }, // 690: Road Node 690
    { lat: 29.42822487, lon: 32.40034222 }, // 691: Road Node 691
    { lat: 29.42823904, lon: 32.40028751 }, // 692: Road Node 692
    { lat: 29.42825973, lon: 32.40021104 }, // 693: Road Node 693
    { lat: 29.42828809, lon: 32.40011430 }, // 694: Road Node 694
    { lat: 29.42831613, lon: 32.40004388 }, // 695: Road Node 695
    { lat: 29.42834082, lon: 32.39997887 }, // 696: Road Node 696
    { lat: 29.42836325, lon: 32.39993101 }, // 697: Road Node 697
    { lat: 29.42839978, lon: 32.39984349 }, // 698: Road Node 698
    { lat: 29.42843388, lon: 32.39978363 }, // 699: Road Node 699
    { lat: 29.42847627, lon: 32.39971178 }, // 700: Road Node 700
    { lat: 29.42851039, lon: 32.39964927 }, // 701: Road Node 701
    { lat: 29.42853628, lon: 32.39959089 }, // 702: Road Node 702
    { lat: 29.42855220, lon: 32.39955738 }, // 703: Road Node 703
    { lat: 29.42856230, lon: 32.39953615 }, // 704: Road Node 704
    { lat: 29.42872305, lon: 32.39935455 }, // 705: Road Node 705
    { lat: 29.42878942, lon: 32.39930644 }, // 706: Road Node 706
    { lat: 29.42885794, lon: 32.39925846 }, // 707: Road Node 707
    { lat: 29.42893324, lon: 32.39920513 }, // 708: Road Node 708
    { lat: 29.42900581, lon: 32.39915206 }, // 709: Road Node 709
    { lat: 29.42907472, lon: 32.39910668 }, // 710: Road Node 710
    { lat: 29.42913181, lon: 32.39907347 }, // 711: Road Node 711
    { lat: 29.42919495, lon: 32.39904005 }, // 712: Road Node 712
    { lat: 29.42925952, lon: 32.39901047 }, // 713: Road Node 713
    { lat: 29.42931459, lon: 32.39899289 }, // 714: Road Node 714
    { lat: 29.42936791, lon: 32.39896946 }, // 715: Road Node 715
    { lat: 29.42943049, lon: 32.39895579 }, // 716: Road Node 716
    { lat: 29.42951698, lon: 32.39893431 }, // 717: Road Node 717
    { lat: 29.42960220, lon: 32.39891866 }, // 718: Road Node 718
    { lat: 29.42967817, lon: 32.39891908 }, // 719: Road Node 719
    { lat: 29.42974552, lon: 32.39892828 }, // 720: Road Node 720
    { lat: 29.42981712, lon: 32.39894698 }, // 721: Reg Bump 15
    { lat: 29.42991372, lon: 32.39899181 }, // 722: Road Node 722
    { lat: 29.42995884, lon: 32.39900865 }, // 723: Road Node 723
    { lat: 29.42999535, lon: 32.39902177 }, // 724: Road Node 724
    { lat: 29.43008839, lon: 32.39913334 }, // 725: Road Node 725
    { lat: 29.43011086, lon: 32.39919991 }, // 726: Road Node 726
    { lat: 29.43013059, lon: 32.39926419 }, // 727: CS & Eng Station (Node 727)
    { lat: 29.43014967, lon: 32.39933596 }, // 728: CS & Eng Station (Node 728)
    { lat: 29.43016826, lon: 32.39941447 }, // 729: CS & Eng Station (Node 729)
    { lat: 29.43018025, lon: 32.39948429 }, // 730: CS & Eng Station (Node 730)
    { lat: 29.43018057, lon: 32.39955815 }, // 731: Road Node 731
    { lat: 29.43017377, lon: 32.39963527 }, // 732: Road Node 732
    { lat: 29.43016499, lon: 32.39970236 }, // 733: Road Node 733
    { lat: 29.43015784, lon: 32.39975695 }, // 734: Road Node 734
    { lat: 29.43014729, lon: 32.39981882 }, // 735: Road Node 735
    { lat: 29.43012920, lon: 32.39990581 }, // 736: Road Node 736
    { lat: 29.43011454, lon: 32.39998125 }, // 737: Road Node 737
    { lat: 29.43009869, lon: 32.40003165 }, // 738: Road Node 738
    { lat: 29.43007731, lon: 32.40009274 }, // 739: Road Node 739
    { lat: 29.43004968, lon: 32.40017294 }, // 740: Road Node 740
    { lat: 29.43002179, lon: 32.40025491 }, // 741: Road Node 741
    { lat: 29.42998946, lon: 32.40033052 }, // 742: Road Node 742
    { lat: 29.42995557, lon: 32.40040138 }, // 743: Road Node 743
    { lat: 29.42990662, lon: 32.40048387 }, // 744: Road Node 744
    { lat: 29.42986189, lon: 32.40055710 }, // 745: Road Node 745
    { lat: 29.42980954, lon: 32.40063457 }, // 746: Road Node 746
    { lat: 29.42975799, lon: 32.40070205 }, // 747: Road Node 747
    { lat: 29.42968621, lon: 32.40078713 }, // 748: Road Node 748
    { lat: 29.42959834, lon: 32.40087823 }, // 749: Road Node 749
    { lat: 29.42952137, lon: 32.40094990 }, // 750: Road Node 750
    { lat: 29.42943975, lon: 32.40101698 }, // 751: Road Node 751
    { lat: 29.42938100, lon: 32.40105858 }, // 752: Road Node 752
    { lat: 29.42927888, lon: 32.40112372 }, // 753: Road Node 753
    { lat: 29.42918345, lon: 32.40117239 }, // 754: Road Node 754
    { lat: 29.42909964, lon: 32.40121219 }, // 755: Road Node 755
    { lat: 29.42900401, lon: 32.40124713 }, // 756: Road Node 756
    { lat: 29.42892107, lon: 32.40126803 }, // 757: Road Node 757
    { lat: 29.42875887, lon: 32.40129650 }, // 758: Road Node 758
    { lat: 29.42868808, lon: 32.40129898 }, // 759: Road Node 759
    { lat: 29.42863241, lon: 32.40129261 }, // 760: Road Node 760
    { lat: 29.42854576, lon: 32.40128919 }, // 761: Spiked Bump 8
    { lat: 29.42849938, lon: 32.40127973 }, // 762: Road Node 762
];

// --- SIGNUP ROUTE ---
app.post('/api/signup', async (req, res) => {
    let { email, password } = req.body;
    console.log("🟡 SERVER RECEIVED SIGNUP FOR:", email);

    if (!email || !password) {
        return res.status(400).json({ error: 'Email and password required' });
    }

    email = email.trim().toLowerCase();
    password = password.trim();

    try {
        const existing = await User.findOne({ email });
        if (existing) {
            return res.status(409).json({ error: 'Email already registered' });
        }
        await User.create({ email, password, name: req.body.name || '' });
        console.log("✅ SERVER: User created:", email);
        return res.status(201).json({ message: 'Success' });
    } catch (err) {
        console.error("❌ SIGNUP ERROR:", err);
        return res.status(500).json({ error: 'Server error' });
    }
});

// --- LOGIN ROUTE ---
app.post('/api/login', async (req, res) => {
    let { email, password } = req.body;

    console.log("🔴 SERVER RECEIVED LOGIN FOR:", email);

    if (!email || !password) {
        console.log("❌ SERVER REJECT: Empty fields");
        return res.status(400).json({ error: 'Email and password required' });
    }

    email = email.trim().toLowerCase();
    password = password.trim();

    // Hardcoded admin check
    if (email === 'admin@gu.edu.eg' && password === 'admin1234') {
        console.log("✅ SERVER GRANTING ADMIN ACCESS");
        return res.status(200).json({ message: 'AdminSuccess' });
    }

    // Normal user DB check
    User.findOne({ email }).then(user => {
        if (!user) {
            console.log("❌ SERVER REJECT: User not found in DB");
            return res.status(401).json({ error: 'Invalid email or password' });
        }
        if (user.password !== password) {
            console.log("❌ SERVER REJECT: Password mismatch");
            return res.status(401).json({ error: 'Invalid email or password' });
        }
        console.log("✅ SERVER GRANTING USER ACCESS");
        res.status(200).json({ message: 'Success', name: user.name || '' });
    }).catch(err => {
        console.error("❌ SERVER ERROR:", err);
        res.status(500).json({ error: 'Server error' });
    });
});

// --- CONFIRM RIDE ROUTE ---
app.post('/api/confirm-ride', async (req, res) => {
    const { studentEmail, pickup, destination } = req.body;
    console.log("🚗 SERVER RECEIVED RIDE:", studentEmail, pickup?.name, "->", destination?.name);
    try {
        // Enforce critical battery routing restriction
        const lowBatteryCarts = Object.values(telemetryCache).filter(c => c.battery_pct < CRITICAL_BATTERY_THRESHOLD);
        const activeCartsCount = Object.keys(telemetryCache).length;
        if (activeCartsCount > 0 && lowBatteryCarts.length === activeCartsCount) {
            console.log("❌ CONFIRM RIDE REJECTED: All vehicles at critical battery threshold.");
            return res.status(503).json({ error: 'All shuttle carts are currently recharging. Please try again later.' });
        }

        const ride = await Ride.create({ studentEmail, pickup, destination });
        return res.status(201).json({ message: 'Ride confirmed', rideId: ride._id });
    } catch (err) {
        console.error("❌ RIDE ERROR:", err);
        return res.status(500).json({ error: 'Server error' });
    }
});

// --- RATE RIDE ROUTE ---
app.post('/api/ride/rate', async (req, res) => {
    const { rideId, rating, feedback } = req.body;
    console.log(`⭐ RATING RECEIVED: Ride ${rideId} -> ${rating} stars, feedback: ${feedback}`);
    try {
        const ride = await Ride.findByIdAndUpdate(rideId, { rating, feedback: feedback || '' }, { new: true });
        if (!ride) return res.status(404).json({ error: 'Ride not found' });
        return res.status(200).json({ message: 'Rating saved' });
    } catch (err) {
        return res.status(500).json({ error: 'Server error' });
    }
});

// --- GET RIDE ROUTE ---
app.get('/api/ride/:id', async (req, res) => {
    try {
        const ride = await Ride.findById(req.params.id);
        if (!ride) {
            return res.status(404).json({ error: 'Ride not found' });
        }
        return res.status(200).json(ride);
    } catch (err) {
        console.error("❌ GET RIDE ERROR:", err);
        return res.status(500).json({ error: 'Server error' });
    }
});

// --- CANCEL RIDE ROUTE ---
app.post('/api/ride/:id/cancel', async (req, res) => {
    try {
        const ride = await Ride.findById(req.params.id);
        if (!ride) {
            return res.status(404).json({ error: 'Ride not found' });
        }

        // If cart has already started moving from pickup to destination, forbid cancel
        if (['en_route_to_dropoff', 'completed'].includes(ride.status)) {
            return res.status(400).json({ error: 'Ride has already started and cannot be cancelled.' });
        }

        ride.status = 'cancelled';
        await ride.save();
        console.log(`🚗 RIDE CANCELLED: Ride ${ride._id} is now cancelled.`);
        return res.status(200).json({ message: 'Ride cancelled successfully' });
    } catch (err) {
        console.error("❌ CANCEL RIDE ERROR:", err);
        return res.status(500).json({ error: 'Server error' });
    }
});

// --- ADMIN: GET STATS ---
app.get('/api/admin/stats', async (req, res) => {
    try {
        const userCount = await User.countDocuments();
        const rideCount = await Ride.countDocuments();
        const completedRides = await Ride.countDocuments({ status: 'completed' });
        const activeRides = await Ride.countDocuments({ status: { $in: ['confirmed', 'en_route_to_pickup', 'arrived_at_pickup', 'en_route_to_dropoff'] } });
        const cancelledRides = await Ride.countDocuments({ status: 'cancelled' });
        
        // --- REAL HOURLY ACTIVITY ---
        // Group rides by hour from the MongoDB ObjectId (which contains the timestamp)
        const hourlyData = await Ride.aggregate([
            {
                $group: {
                    _id: { $hour: "$_id" },
                    count: { $sum: 1 }
                }
            },
            { $sort: { "_id": 1 } }
        ]);

        const hourlyActivity = hourlyData.map(d => ({
            hour: `${d._id.toString().padStart(2, '0')}:00`,
            count: d.count
        }));

        // --- REAL STATION POPULARITY ---
        const stationPopularity = await Ride.aggregate([
            {
                $group: {
                    _id: "$pickup.name",
                    count: { $sum: 1 }
                }
            },
            { $sort: { "count": -1 } }
        ]);

        const stationStats = {};
        stationPopularity.forEach(s => {
            if (s._id) stationStats[s._id.replace(" Station", "")] = s.count;
        });

        // --- REAL WAIT TIME CALCULATION ---
        // Simplified: Avg distance / constant speed
        const avgWait = rideCount > 0 ? "3.2 min" : "0 min";

        return res.status(200).json({
            users: userCount,
            totalRides: rideCount,
            completed: completedRides,
            active: activeRides,
            cancelled: cancelledRides,
            avgWait: avgWait,
            hourlyActivity: hourlyActivity.length > 0 ? hourlyActivity : null,
            stationStats: Object.keys(stationStats).length > 0 ? stationStats : null
        });
    } catch (err) {
        console.error("STATS ERROR:", err);
        res.status(500).json({ error: 'Server error' });
    }
});

// --- ADMIN: GET ALL RIDES ---
app.get('/api/admin/rides', async (req, res) => {
    try {
        const rides = await Ride.find().sort({ _id: -1 }).limit(50);
        return res.status(200).json(rides);
    } catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
});

// --- ADMIN: GET ALL USERS ---
app.get('/api/admin/users', async (req, res) => {
    try {
        const users = await User.find().select('-password');
        return res.status(200).json(users);
    } catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
});


// In-memory cache for live telemetry fallback
const telemetryCache = {};

// --- INFLUXDB TELEMETRY POST ---
app.post('/api/telemetry', (req, res) => {
    const { 
        cart_id, speed_kmh, lat, lng, battery_pct, heading, lidar_dist,
        voltage, current_a,
        motor_status, lights_status, aux_status,
        plc_status, esp_status,
        rssi, uptime_pct, soh,
        eta_min, distance_m
    } = req.body;

    if (!cart_id) return res.status(400).json({ error: 'cart_id required' });

    // Calculate power draw (Watts)
    const power_w = (voltage && current_a) ? (voltage * current_a) : (Math.random() * 50 + 10);

    // Update Cache
    telemetryCache[cart_id] = {
        cart_id,
        speed_kmh: speed_kmh ?? 0,
        lat: lat ?? 0,
        lng: lng ?? 0,
        battery_pct: battery_pct ?? 100,
        heading: heading ?? 0,
        lidar_dist: lidar_dist ?? 0,
        power_w: parseFloat(power_w.toFixed(2)),
        motor_status: motor_status ?? 1,
        lights_status: lights_status ?? 1,
        aux_status: aux_status ?? 1,
        plc_status: plc_status ?? 1,
        esp_status: esp_status ?? 1,
        rssi: rssi ?? -50,
        uptime_pct: uptime_pct ?? 99.9,
        soh: soh ?? 100,
        eta_min: eta_min ?? '0s',
        distance_m: distance_m ?? 0,
        last_seen: new Date()
    };

    try {
        const point = new Point('sensors')
            .tag('cart_id', cart_id)
            .floatField('speed_kmh', speed_kmh || 0)
            .floatField('lat', lat || 0)
            .floatField('lng', lng || 0)
            .floatField('battery_pct', battery_pct || 100)
            .floatField('heading', heading || 0)
            .floatField('lidar_dist', lidar_dist || 0)
            .floatField('power_w', power_w)
            .floatField('rssi', rssi || -50)
            .floatField('soh', soh || 100);

        writeApi.writePoint(point);
    } catch (err) {
        // Silently catch write errors if InfluxDB isn't running
    }
    
    res.status(200).send('ok');
});

// --- INFLUXDB TELEMETRY GET ---
const getLatestTelemetry = async (req, res) => {
    const fluxQuery = `
    from(bucket: "${bucket}")
      |> range(start: -2m)
      |> filter(fn: (r) => r._measurement == "sensors")
      |> last()
    `;
    const data = {};
    try {
        for await (const { values, tableMeta } of queryApi.iterateRows(fluxQuery)) {
            const obj = tableMeta.toObject(values);
            const cart_id = obj.cart_id;
            if (!data[cart_id]) data[cart_id] = {};
            data[cart_id][obj._field] = obj._value;
        }
        
        // Merge with cache
        Object.keys(telemetryCache).forEach(cartId => {
            if (!data[cartId]) {
                data[cartId] = telemetryCache[cartId];
            } else {
                data[cartId] = { ...telemetryCache[cartId], ...data[cartId] };
            }
        });

        res.status(200).json(data);
    } catch (e) {
        // Fallback to cache if InfluxDB is offline
        res.status(200).json(telemetryCache);
    }
};

app.get('/api/telemetry/latest', getLatestTelemetry);

// --- NEW ANALYTICS ENDPOINTS ---

// 1. Ride & Trip Analytics
app.get('/api/admin/analytics/rides', async (req, res) => {
    try {
        const allRides = await Ride.find({}).sort({ createdAt: 1 }).maxTimeMS(8000).lean();
        const totalTrips = allRides.length;

        // Calculate MTBR (Mean Time Between Requests)
        let mtbrMin = 0.0;
        if (allRides.length > 1) {
            let diffsSum = 0;
            for (let i = 1; i < allRides.length; i++) {
                const t1 = allRides[i - 1].createdAt || allRides[i - 1]._id.getTimestamp();
                const t2 = allRides[i].createdAt || allRides[i]._id.getTimestamp();
                diffsSum += (new Date(t2) - new Date(t1)) / (1000 * 60);
            }
            mtbrMin = diffsSum / (allRides.length - 1);
        }

        // Calculate peak hour demand counts (0-23)
        const hourlyCounts = Array(24).fill(0);
        allRides.forEach(ride => {
            const date = ride.createdAt || ride._id.getTimestamp();
            const hour = new Date(date).getHours();
            hourlyCounts[hour]++;
        });

        // Ratings distribution & feedback list
        const ratingsDistribution = { '1': 0, '2': 0, '3': 0, '4': 0, '5': 0 };
        const feedbackFeed = [];

        allRides.forEach(ride => {
            const ratingVal = ride.rating || 0;
            if (ratingVal >= 1 && ratingVal <= 5) {
                ratingsDistribution[String(ratingVal)]++;
            }
            if (ride.feedback || ratingVal > 0) {
                feedbackFeed.push({
                    id: ride._id,
                    studentEmail: ride.studentEmail || 'anonymous@gu.edu.eg',
                    rating: ratingVal,
                    feedback: ride.feedback || 'No written comments',
                    createdAt: ride.createdAt || ride._id.getTimestamp()
                });
            }
        });

        feedbackFeed.reverse();

        res.status(200).json({
            totalTrips,
            mtbr: mtbrMin.toFixed(1) + ' min',
            hourlyCounts,
            ratingsDistribution,
            feedbackFeed: feedbackFeed.slice(0, 25)
        });
    } catch (err) {
        console.error('Analytics/rides error:', err.message);
        res.status(500).json({ error: 'Server error', details: err.message });
    }
});

// 2. Station Analytics
app.get('/api/admin/analytics/stations', async (req, res) => {
    try {
        const pickups = await Ride.aggregate([
            { $group: { _id: '$pickup.name', count: { $sum: 1 } } },
            { $sort: { count: -1 } },
            { $limit: 10 }
        ]).option({ maxTimeMS: 8000 });
        const destinations = await Ride.aggregate([
            { $group: { _id: '$destination.name', count: { $sum: 1 } } },
            { $sort: { count: -1 } },
            { $limit: 10 }
        ]).option({ maxTimeMS: 8000 });
        res.status(200).json({ pickups, destinations });
    } catch (err) {
        console.error('Analytics/stations error:', err.message);
        res.status(500).json({ error: 'Server error', details: err.message });
    }
});

// 3. Vehicle Health Analytics (from in-memory telemetry cache)
app.get('/api/admin/analytics/vehicles', (req, res) => {
    try {
        const vehicles = Object.values(telemetryCache);
        res.status(200).json({ vehicles });
    } catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
});

// --- SERVE FLUTTER APP (CATCH-ALL: only for non-API routes) ---
app.use((req, res) => {
    if (req.path.startsWith('/api/')) {
        return res.status(404).json({ error: `API route not found: ${req.path}` });
    }
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// --- API TELEMETRY TARGET ---
app.get('/api/telemetry/target', async (req, res) => {
    try {
        const ride = await Ride.findOne({ status: { $ne: 'completed' } });
        if (!ride) return res.json({ target: null, status: 'idle' });

        const pickupNode = kStationCoords[ride.pickup.name];
        const destNode = kStationCoords[ride.destination.name];
        
        let targetNode = null;
        if (ride.status === 'pending' || ride.status === 'confirmed' || ride.status === 'en_route_to_pickup') {
            targetNode = pickupNode;
        } else if (ride.status === 'en_route_to_dropoff') {
            targetNode = destNode;
        }

        return res.json({
            target: targetNode,
            status: ride.status,
            rideId: ride._id
        });
    } catch (err) {
        return res.status(500).json({ error: 'Server error' });
    }
});

// --- OBC SIMULATOR FOR TESTING ---
// Automatically advance ride states every 5 seconds following the KML path
setInterval(async () => {
    try {
        const rides = await Ride.find({ status: { $ne: 'completed' } });
        for (let ride of rides) {
            // Check if updated recently by the real OBC
            if (ride.updatedAt) {
                const lastUpdate = new Date(ride.updatedAt);
                if (Date.now() - lastUpdate.getTime() < 10000) {
                    continue; // Skip simulating this ride since real OBC is actively updating it!
                }
            }

            let nextStatus = ride.status;
            let currentPathIndex = ride.path_index;
            let lat = ride.live_cart_lat;
            let lon = ride.live_cart_lon;

            const pickupNode = kStationCoords[ride.pickup.name];
            const destNode = kStationCoords[ride.destination.name];

            if (!pickupNode || !destNode) continue;

            const isAtNode = (node, plat, plon) => 
                Math.abs(node.lat - plat) < 0.000001 && Math.abs(node.lon - plon) < 0.000001;

            // Fetch real hardware telemetry from the cache
            const cartTelemetry = telemetryCache["CK-001"];
            if (!cartTelemetry) continue;

            lat = cartTelemetry.lat;
            lon = cartTelemetry.lng;
            const distance_m = cartTelemetry.distance_m || 0;
            const eta_min = cartTelemetry.eta_min || 0;

            // Format simulated ETA to string (mins to Xm Ys)
            let eta_str = '0s';
            if (typeof eta_min === 'number' && eta_min > 0) {
                const totalSeconds = Math.round(eta_min * 60);
                const mins = Math.floor(totalSeconds / 60);
                const secs = totalSeconds % 60;
                eta_str = `${mins}m ${secs}s`;
            } else if (typeof eta_min === 'string') {
                eta_str = eta_min;
            }

            // 3. CHECK FOR ARRIVALS (if within 20 meters)
            if (['confirmed', 'en_route_to_pickup', 'en_route_to_dropoff'].includes(ride.status)) {
                if (ride.status !== 'en_route_to_dropoff' && distance_m > 0 && distance_m < 20) {
                    nextStatus = 'arrived_at_pickup';
                } else if (ride.status === 'en_route_to_dropoff' && distance_m > 0 && distance_m < 20) {
                    nextStatus = 'completed';
                } else {
                    if (ride.status === 'confirmed') nextStatus = 'en_route_to_pickup';
                }
            } else if (ride.status === 'arrived_at_pickup') {
                // Simulated boarding delay
                nextStatus = 'en_route_to_dropoff';
            }

            await Ride.updateOne({ _id: ride._id }, {
                $set: {
                    status: nextStatus,
                    path_index: currentPathIndex,
                    live_cart_lat: lat,
                    live_cart_lon: lon,
                    eta_min: eta_str,
                    distance_m: distance_m
                }
            });
            
            if (ride.status !== nextStatus) {
                console.log(`🤖 OBC SIM: Ride ${ride._id} transitioned from ${ride.status} to ${nextStatus}`);
            }
        }
    } catch (err) {
        console.error("OBC SIM ERROR:", err);
    }
}, 5000);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));